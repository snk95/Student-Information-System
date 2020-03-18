require 'dm-core'
require 'dm-migrations'
require 'erb'
require 'dm-timestamps'




class Comment              # first type require./comment in irb to make available this file and then Comment.auto_migrate! to create database file.
                           # Now crete table by using object Comment. The table name will be same as erb filename
  include DataMapper::Resource
  
  property :id, Serial     
  property :username, String
  property :created_at, DateTime
  property :content, Text
end

#verify table
DataMapper.finalize

