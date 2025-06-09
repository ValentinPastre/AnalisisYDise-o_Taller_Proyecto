require 'bundler/setup'
require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/account'
require 'sinatra/base'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'

class App < Sinatra::Application
  enable :sessions

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
    cuil: cuil
    )
    if user.save
      account = user.build_account(
        email: email,
        password: password, 
        password_confirmation: confirm
      )
      if account.save
        #cuenta creada exitosamente
      else
        user.destroy
      end
    end
    
    redirect '/login'
  end


  get '/logout' do 
    session.clear
    redirect '/login'
  end 

  get '/welcome' do  
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @balance = @account&.balance || "Vacío"
    erb :welcome
  end 
# Ruta para mostrar el formulario de ahorro
get '/saving' do
  redirect '/login' unless session[:user_id]
  @user = User.find(session[:user_id])
  @account = @user.account
  erb :saving
end

# Ruta para procesar el nuevo ahorro
post '/saving' do
  redirect '/login' unless session[:user_id]
  
  @user = User.find(session[:user_id])
  @account = @user.account
  
  @saving = @account.savings.new(
    name: params[:saving][:name],
    amount: params[:saving][:amount]
  )
  
  if @saving.save
    redirect '/savings_list'
  else
    # Mostrar errores si la validación falla
    erb :saving
  end
end

# Ruta para listar ahorros
get '/savings_list' do
  redirect '/login' unless session[:user_id]
  
  @user = User.find(session[:user_id])
  @account = @user.account
  @savings = @account.savings  # Esto carga todos los ahorros de la cuenta
  
  erb :savings_list
end

# Ruta para eliminar ahorros
delete '/saving/:id' do
  redirect '/login' unless session[:user_id]
  
  saving = Saving.find(params[:id])
  saving.destroy
  redirect '/savings_list'
end

  get '/alias' do
    redirect 'login' unless session[:user_id]

    usuario = User.find(session[:user_id])
    cuenta = usuario.account

    @alias = cuenta.alias
    @cvu = cuenta.cvu

    erb :alias
  end

  get '/change_alias' do
    redirect 'login' unless session[:user_id]
    erb :change_alias
  end

  post '/change_alias' do
    redirect 'login' unless session[:user_id]

    usuario = User.find(session[:user_id])
    cuenta = usuario.account

    new_alias = params[:nuevo_alias].strip

    if new_alias.empty?
      return "El alias no puede estar vacio"
    end

    cuenta.alias = new_alias
    cuenta.save

    redirect '/alias'
  end

  post '/login' do
    email = params[:email]
    password = params[:password]
    account = Account.find_by(email: email)

    if account && account.authenticate(password)
      session[:user_id] = account.user.id
      redirect '/welcome'
    else
      @error = "Email o contraseña incorrectos"
      erb :login
    end
  end
end