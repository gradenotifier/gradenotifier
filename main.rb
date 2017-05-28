require 'sinatra'
require 'twilio-ruby'
require 'json'
require 'data_mapper'
require './student'

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db" )
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get '/' do
	@student = Student.new
	erb :home
end

get '/about' do
	erb :about
end

get '/teachers' do
	erb :teachers
end

get '/contact' do
	erb :contact
end

post '/' do
	student = Student.create(params[:student])
end

post '/sms/receive' do
	content_type 'text/xml'
	response = Twilio::TwiML::Response.new do |r|
		r.Message "I'm a bot. Bleep bloop. Check out gradenotifier.com/help"
	end
	response.to_xml
end

post '/sms/send' do
	client = Twilio::REST::Client.new(
    	ENV['TWILIO_ACCOUNT_SID'],
    	ENV['TWILIO_AUTH_TOKEN']
	)

	students = JSON.parse(params["data"])
	students.each do |id, grade|	
		unless Student.first(:studentNumber => id).nil?
			to = Student.first(:studentNumber => id).phone
			message = 'You got ' + grade + '% on your computer science project.'

		    client.messages.create(
		    	to: to,
		        from: '+12044006198', 
	        	body: message,
	        	media_url: 'https://thumbs.gfycat.com/ScientificShockingCougar-size_restricted.gif'
	    	)
	    	puts "Sent message to " + id
    	end
	end		
end
