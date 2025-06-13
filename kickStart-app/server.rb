require 'bundler/setup'
require 'sinatra/activerecord'
require_relative 'models/user'
require_relative 'models/account'
require_relative 'models/saving'
require_relative 'models/obra_social'
require_relative 'models/notification'
require_relative 'models/link_obra_social_user'
require 'sinatra/base'
require 'sinatra/reloader' if Sinatra::Base.environment == :development
require 'logger'
require_relative 'models/transaction'

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
    erb :login
  end
  
  get '/login' do  
    erb :login
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

    if User.exists?(dni: dni)
      @error = "El dni ya fue registrado"
      return erb :signup
    end
    if User.exists?(cuil: cuil)
      @error = "El cuil ya fue registrado"
      return erb :signup
    end
    if Account.exists?(email: email)
      @error = "El correo ya fue registrado"
      return erb :signup
    end

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
  
# Ruta para mostrar la página de bienvenida 
  get '/welcome' do  
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @balance = @account&.balance || "Vacío"
    @movements = Transaction.where("source_account_id = ? OR target_account_id = ?", @account.id, @account.id)
                            .order(created_at: :desc)
                            .limit(5)
    erb :welcome
  end 

# Ruta para mostrar el historial de transacciones y contactos
  get '/historial' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @movements = Transaction.where("source_account_id = ? OR target_account_id = ?", @account.id, @account.id).order(created_at: :desc)
    @contacts = @movements.map { |mov| mov.target_account&.user }
                      .compact
                      .uniq
                      .reject { |user| user.id == @user.id }
    erb :historial
  end

  get '/contactos' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @contacts = @account.contacts
    erb :contactos
  end

  get '/contactos/agregar' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @contacts = @account.contacts
    erb :contactos_agregar
  end

  post '/contactos/agregar' do
    redirect '/login' unless session[:user_id]
    user = User.find(session[:user_id])
    account = user.account
    alias_ingresado = params[:alias].to_s.strip
    contacto = Account.find_by(alias: alias_ingresado)

    if contacto.nil?
      # mostrar mensaje de error en la vista si querés
      @contacto = Account.new(alias: alias_ingresado)
      @contacto.errors.add(:alias, "No existe ninguna cuenta con el alias ingresado")
      @contacts = account.contacts
      return erb :contactos_agregar
    end
    if contacto == account
      @contacto = Account.new(alias: alias_ingresado)
      @contacto.errors.add(:alias, "No podes ingresarte a vos mismo como contacto")
      @contacts = account.contacts
      return erb :contactos_agregar
    end
    if account.contacts.include?(contacto)
      @contacto = Account.new(alias: alias_ingresado)
      @contacto.errors.add(:alias, "Ya tenes agregado a este contacto en tu lista")
      @contacts = account.contacts
      return erb :contactos_agregar
    end
  
    account.contacts << contacto
    redirect '/contactos'
  end

get '/contactos/eliminar' do
  redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @contacts = @account.contacts
    erb :contactos_eliminar
end

post '/contactos/eliminar' do
  redirect '/login' unless session[:user_id]

  @user = User.find(session[:user_id])
  @account = @user.account
  contacto = Account.find_by(id: params[:contacto_id])

  if contacto && @account.contacts.include?(contacto)
    @account.contacts.delete(contacto)
    redirect '/contactos'
  else
    @error = "Contacto no encontrado o no está en tu lista"
    @contacts = @account.contacts
    erb :contactos
  end
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
    description: params[:saving][:name],
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
    redirect '/login' unless session[:user_id]

    @user = User.find(session[:user_id])
    @cuenta = @user.account

    @alias = @cuenta.alias
    @cvu = @cuenta.cvu

    erb :alias
  end

  get '/change_alias' do
    @user = User.find(session[:user_id])
    @cuenta = @user.account

    redirect '/login' unless session[:user_id]
    erb :change_alias
  end

  post '/change_alias' do
  redirect '/login' unless session[:user_id]

  @user = User.find(session[:user_id])
  @cuenta = @user.account

  nuevo_alias = params[:nuevo_alias].strip

  if nuevo_alias.empty?
    @error = "El alias no puede estar vacío"
    return erb :change_alias
  end

  @cuenta.alias = nuevo_alias

  if @cuenta.save
    redirect '/alias'
  else
    @error = "Ese alias ya está en uso, elegí otro"
    erb :change_alias
  end
end

  get '/obra-social' do
    redirect '/login' unless session[:user_id]

    if session[:obra_social] && session[:credential]
      redirect '/discounts'
    else 
      @user = User.find(session[:user_id])
      erb :obra_social
    end
  end

  post '/obra-social' do
    @user = User.find(session[:user_id])

    session[:obra_social] = params[:obra_social].upcase
    @obra_social = ObraSocial.find_by(name: session[:obra_social])
    
    if @obra_social.nil?
      @error = "La obra social ingresada no está disponible"
      return erb :obra_social
    end
    
    unless params[:documento] == @user.dni
      @error = "El documento ingresado no coincide con el del usuario"
      return erb :obra_social
    end
    
    @link = LinkObraSocialUser.find_by(users_id: session[:user_id], obras_sociales_id: @obra_social.id)
    if @link.nil?
      @error = "No se encontraron datos asociados a esta obra social y usuario"
      return erb :obra_social
    end

    unless params[:credencial].strip == @link.credential.to_s.strip
      @error = "La credencial ingresada es incorrecta"
      return erb :obra_social
    end 

    # para evitar redirect /login cuando la credencial es incorrecta
    session[:credential] = @link.credential

    redirect '/discounts'
  end

  get '/discounts' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @cuenta = @user.account
    @obra_social = ObraSocial.find_by(name: session[:obra_social])

    @notifications = Notification.where(
      account_id: @cuenta.id,
      obras_sociales_id: @obra_social.id
    )

    erb :discounts
  end

  get '/transferir' do
    redirect '/login' unless session[:user_id]
    
    @user = User.find(session[:user_id])
    @account = @user.account
    @contacts = @account.source_transactions.map { |mov| mov.target_account&.user }.compact.uniq

    erb :transferir
  end

  get '/transferencia' do
    erb :transferencia
  end

  post '/transferencia' do
    redirect '/login' unless session[:user_id]
    monto = params[:monto].to_f
    destino = params[:destino]&.strip

    @user = User.find(session[:user_id])
    @account = @user.account

    # Buscar cuenta destino por alias, cvu o email
    dest_account = Account.find_by(alias: destino) || Account.find_by(cvu: destino) || Account.find_by(email: destino)

    if dest_account.nil?
      @balance = @account.balance
      @destino = destino
      @error = "No se encontró la cuenta destino."
      return erb :transferencia
    end

    if monto <= 0
      @balance = @account.balance
      @destino = destino
      @error = "El monto debe ser mayor a 0."
      return erb :transferencia
    end

    if @account.balance < monto
      @balance = @account.balance
      @destino = destino
      @error = "No tienes saldo suficiente."
      return erb :transferencia
    end

    # Crear la transacción (esto actualiza los saldos por el callback en Transaction)
    Transaction.create!(
      source_account: @account,
      target_account: dest_account,
      amount: monto
    )

    redirect '/welcome'
  end

  
end