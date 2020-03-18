require 'rubygems' 
require 'sinatra'

require 'dm-sqlite-adapter'
require 'sinatra/reloader' if development?
require 'dm-core'
require 'dm-migrations'
require 'erb'
require 'dm-timestamps'
require './student'
require './comment'  

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/snk.db")

configure :development do
  # setup sqlite database
      DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/snk.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end


configure do
  #admin user credentails
  enable :sessions
  set :username, "snk"
  set :password, "12345"
end



################## Home page  
get '/' do
  @title="home"
  erb :home         
end

################### Contact
get '/contact' do
  @title="contact"
  erb :contact
end

################### About
get '/about' do
  @title="about"
  erb :about
end

################## Comments
get '/comments'  do
  @comments= Comment.all
  @title="comment"   
  erb :comments 
end

# add comment page
get '/comments/new' do
  erb :comment_add
end

# add new comment into database
post '/comments/new' do
  username = params[:username]
  comment = params[:comment]
  Comment.create(username: username.to_s, content: comment)
  redirect '/comments'
end

get '/comments/:id' do
  @comments = Comment.get(params[:id])
  erb :comment_show
end


################## Login/Logout page  
get '/login' do
  @title="login" 
        if session[:admin]
                "You have already logged in."
        else
                erb :login
        end
end

post '/login' do
        if params[:username] == settings.username && params[:password] == settings.password
                session[:admin] = true
                redirect '/'
        else
                erb :login_fail
        end
end

get '/logout' do
  @title="logout" 
        session.clear
        erb :logout
end       


################## Students Information
get '/students' do
  @title="student"
  @students= Student.all
  erb :students
end

# add student page
get '/students/new' do
  #check if user login
  if !session[:admin]
        redirect '/students'
    end
  
  temp = Student.all(:order => :id.asc)
  if temp.count != 0
    @new_id = temp.last.id + 1
  else
    @new_id = 1
  end
  erb :student_add
end

# populate data to DB
post '/students/new' do
  # check whether id duplicate
        Student.all.each do |x|
          if x.id == params[:id].to_i
            @msg = "Pleae enter the different ID!"
            @students = Student.all
            @title = "Students"
            return erb :students
          end
  end
  id = params[:id]
  firstname = params[:firstname]
  lastname = params[:lastname]
  birthday = params[:birthday]
  address = params[:address]
  Student.create(id: id, firstname: firstname.to_s, lastname: lastname.to_s, birthday: birthday, address: address.to_s)
  redirect '/students'
end

# student information page
get '/students/:id' do
  @students = Student.get(params[:id])
  erb :student_show
end

# student edify page
get '/students/:id/edit' do
  @students = Student.get(params[:id])
  erb :student_edit
end

# update information
post '/students/:id/edit' do

  firstname = params[:firstname]
  lastname = params[:lastname]
  birthday = params[:birthday]
  address = params[:address]
  Student.get(params[:id]).update(firstname: firstname.to_s, lastname: lastname.to_s, birthday: birthday, address: address.to_s)
  redirect '/students'
end

# delete student information
post '/students/:id/delete' do
  Student.get(params[:id]).destroy
  redirect '/students'
end

################## Video
get '/video' do
  @title="video"
  erb :video
end

not_found do                               
  @title="notfound"
  erb :notfound
end 