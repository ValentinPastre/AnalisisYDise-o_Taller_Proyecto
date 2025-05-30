require 'bundler/setup'
require 'sinatra/activerecord'
require_relative 'models/user'
#require_relative 'models/account'
require 'sinatra/base'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'

class App < Sinatra::Application

  configure :development do
    enable :logging
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
    set :views, File.dirname(__FILE__) + '/views'
    set :public_folder, File.dirname(__FILE__) + '/public'

    register Sinatra::Reloader
    after_reload do
      logger.info 'Reloaded!!!'
    end
  end

  get '/' do
    erb :inicio
  end
  
  get '/login' do  
    erb :login
  end 
  
  get '/signup' do  
    erb :signup
  end 
  
  post '/signup' do

    dni = params[:dni]
    email = params[:email]
    password = params[:password]
    confirm = params[:confirmPassword]
    name = params[:name]
    last_name = params[:lastname]

    user = User.new(
    dni: dni,
    email: email,
    name: name,
    lastname: last_name
    )
    user.save
    redirect '/login'
  end


  get '/logout' do 
    session.clear
    redirect '/login'
  end 

end