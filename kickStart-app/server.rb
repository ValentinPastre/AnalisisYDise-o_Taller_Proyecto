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
    lastname = params[:lastname]
    cuil = params[:cuil]

    user = User.new(
    dni: dni,
    name: name,
    lastname: lastname,
    email: email,
    cuil: cuil,
    password: password,
    password_confirmation: confirm
    )
    user.save

    # Agregar creación de account y manejo de error en caso que no se cree el usuario

    redirect '/login'
  end


  get '/logout' do 
    session.clear
    redirect '/login'
  end 

  get '/welcome' do  
    erb :welcome
  end 

  post '/login' do
    redirect '/welcome'
  end

  
end