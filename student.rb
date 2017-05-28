require 'dm-core'
require 'dm-migrations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :studentNumber, String
  property :phone, String
end
DataMapper.finalize