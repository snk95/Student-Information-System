require 'dm-core'
require 'dm-migrations'
require 'erb'
require 'dm-timestamps'


#define model

class Student
  
  include DataMapper::Resource

  property :id, Integer, :key => true
  property :firstname, String
  property :lastname, String
  property :birthday, Date
  property :address, Text
end

#verify table
DataMapper.finalize

