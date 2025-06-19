require 'bundler/setup'
require 'sinatra/activerecord'
require 'sinatra'
require 'bigdecimal'  # si usas BigDecimal

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
require_relative 'models/confident'
require_relative 'models/security_question'
require_relative 'models/service'
require_relative 'models/agua'
require_relative 'models/luz'
require_relative 'models/gas'
require_relative 'models/transportation_card'

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
    redirect '/login' unless session[:user_id]
    redirect '/welcome'
  end
  
  get '/login' do  
    @hide_header = true
    erb :login
  end 

  post '/login' do
    @hide_header = true
    email = params[:email]
    password = params[:password]
    account = Account.find_by(email: email)

    if account && account.authenticate(password) && !account.deleted
      session[:user_id] = account.user.id
      session[:next_url] = '/welcome'
      redirect '/security-question'
    elsif account && account.deleted
      @error = "La cuenta no existe o fue desactivada"
      erb :login
    else
      @error = "Email o contraseña incorrectos"
      erb :login
    end
  end
  
  get '/signup' do  
    @hide_header = true
    erb :signup
  end 
  
  post '/signup' do
    @hide_header = true
    dni = params[:dni]
    email = params[:email]
    password = params[:password]
    confirm = params[:confirmPassword]
    name = params[:name]
    lastname = params[:lastname]
    cuil = params[:cuil]

    if Account.joins(:user).exists?(users: { dni: dni }, deleted: true)
      session[:next_url] = '/restore-account'
      session[:restore_email] = email
      session[:restore_password] = password
      session[:restore_dni] = dni
      redirect '/security-question'
    end
    
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

  get '/restore-account' do
    @hide_header = true
    erb :restore_account    
  end

  post '/restore-account' do
    @hide_header = true
    email = session.delete(:restore_email)
    password = session.delete(:restore_password)
    dni = session.delete(:restore_dni)
    @account = Account.joins(:user).find_by(users: { dni: dni }, deleted: true)

    @account.update(deleted: false)
    if @account
      @account.update(email: email, password: password, password_confirmation: password)
    else
      @errors = "No es posible recuperar la cuenta"
      return erb :signup
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
    @contacts_target = @movements.map { |mov| mov.target_account&.user }
                      .compact
                      .uniq
                      .reject { |user| user.id == @user.id }

    
    @contacts_source = @movements.map { |mov| mov.source_account&.user }
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


# Ruta para el menú principal de ahorros
get '/savings' do
  redirect '/login' unless session[:user_id]
  @user = User.find(session[:user_id])
  @account = @user.account
  erb :savings_menu
end

# Ruta para mostrar el formulario de creación de ahorro
get '/savings/new' do
  redirect '/login' unless session[:user_id]
  @user = User.find(session[:user_id])
  @account = @user.account
  erb :savings_new
end

# Ruta para procesar el nuevo ahorro (POST)
post '/savings' do
  redirect '/login' unless session[:user_id]
  
  @user = User.find(session[:user_id])
  @account = @user.account
  
  @saving = @account.savings.new(
    description: params[:saving][:name],
    amount: params[:saving][:amount]
  )
  
  if @saving.save
    redirect '/savings/list'
  else
    erb :savings_new
  end
end
post '/savings/:id/add' do
  redirect '/login' unless session[:user_id]
  
  saving = Saving.find(params[:id])
  additional_amount = params[:additional_amount].to_f
  
  if saving.add_amount(additional_amount)
    redirect '/savings/list'
  else
    @error = saving.errors.full_messages.join(", ")
    @user = User.find(session[:user_id])
    @account = @user.account
    @savings = @account.savings
    erb :savings_list
  end
end

# Ruta para listar ahorros
get '/savings/list' do
  redirect '/login' unless session[:user_id]
  
  @user = User.find(session[:user_id])
  @account = @user.account
  @savings = @account.savings
  
  erb :savings_list
end

# Ruta para eliminar ahorros (retirar)
delete '/savings/:id' do
  redirect '/login' unless session[:user_id]
  
  saving = Saving.find(params[:id])
  saving.destroy
  redirect '/savings/list'
end

  get '/alias' do
    redirect '/login' unless session[:user_id]

    @user = User.find(session[:user_id])
    @cuenta = @user.account

    @alias = @cuenta.alias
    @cvu = @cuenta.cvu
    @virtual_card = @cuenta.virtual_debit_card 

    erb :alias
  end

  post '/generate_virtual_card' do
  redirect '/login' unless session[:user_id]
  
  user = User.find(session[:user_id])
  account = user.account
  
  # Eliminar tarjeta existente si existe
  account.virtual_debit_card&.destroy
  
  # Crear nueva tarjeta
  account.generate_virtual_debit_card
  redirect '/alias'
  @error = "Error al generar la tarjeta"
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
    @contacts = @account.contacts #@account.source_transactions.map { |mov| mov.target_account&.user }.compact.uniq

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

  get '/profile' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @confident = @account.confidents
    @secq = [@account.security_question].compact
    erb :profile
  end

  get '/confidente_agregar' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @confident = @account.confidents

    erb :confidente_agregar
  end
  
  post '/confidente_agregar' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    Confident.create(account_id: @account.id, email: params[:email])
    redirect '/profile'
  end

  post '/confidente_eliminar' do
    redirect '/login' unless session[:user_id]
    
    conf = Confident.find(params[:confident_id])
    conf.destroy
    redirect '/profile'
  end

  get '/security-question-agregar' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    erb :security_question_agregar
  end

  post '/security-question-agregar' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    SecurityQuestion.create(user_id: @user.id, account_id: @account.id, question: params[:question], answer: params[:answer].upcase)
    redirect '/profile'
  end

  post '/security-question-eliminar' do
    redirect '/login' unless session[:user_id]

    secquestion = SecurityQuestion.find(params[:sq_id])
    secquestion.destroy
    redirect '/profile'
  end

  get '/security-question' do
    unless session[:user_id] || session[:next_url]
      redirect '/login'
    end
    if session[:user_id]
      @user = User.find(session[:user_id])
      @account = @user.account
    else
      dni = session[:restore_dni]
      @user = User.find_by(dni: dni)
      @account = Account.find_by(user: @user.id)
    end
    @secq = @account.security_question

    erb :security_question
  end

  post '/security-question' do
    unless session[:user_id] || session[:next_url]
      redirect '/login'
    end
    if session[:user_id]
      @user = User.find(session[:user_id])
      @account = @user.account
    else
      dni = session[:restore_dni]
      @user = User.find_by(dni: dni)
      @account = Account.find_by(user: @user.id)
    end
    @secq = @account.security_question

    if (@secq && params[:answer].to_s.upcase.strip == @secq.answer.strip)
      ruta_destino = session.delete(:next_url)
      redirect ruta_destino
    elsif (!@secq)
      ruta_destino = session.delete(:next_url)
      redirect ruta_destino
    else
      @secq.errors.add(:answer, "Respuesta equivocada")
      erb :security_question
    end
  end

  get '/profile/predelete' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    session[:next_url] = '/profile/delete'
    redirect '/security-question'
  end

  get '/profile/delete' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    erb :delete_profile
  end

  post '/profile/delete' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    @account.update(deleted: true)
    session.clear
    
    redirect '/login'
  end

  get '/premodify-email' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    session[:next_url] = '/modify-email'
    redirect '/security-question'
  end

  get '/modify-email' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    erb :modify_email
  end

  post '/modify-email' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    email = params[:email]
    newemail = params[:newemail]

    if email == newemail
      @account.update(email: email)
    else
      @error = "Los emails deben coincidir"
      return erb :modify_email
    end

    redirect '/profile'
  end

  get '/premodify-password' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account

    session[:next_url] = '/modify-password'
    redirect '/security-question'
  end
  
  get '/modify-password' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    
    erb :modify_password
  end

  post '/modify-password' do
    redirect '/login' unless session[:user_id]
    @user = User.find(session[:user_id])
    @account = @user.account
    actpass = params[:actpass].to_s.strip
    newpass  = params[:newpass].to_s.strip
    cnewpass = params[:cnewpass].to_s.strip

    if actpass.empty? || newpass.empty? || cnewpass.empty?
      @error = "Por favor completá todos los campos"
      return erb :modify_password
    end
    # 2) Contraseña actual válida
    unless @account.authenticate(actpass)
      @error = "La contraseña actual es incorrecta"
      return erb :modify_password
    end
    # 3) Coincidencia de nueva contraseña
    unless newpass == cnewpass
      @error = "La nueva contraseña y su confirmación deben coincidir"
      return erb :modify_password
    end
    # 4) Intentar guardar la nueva contraseña
    if @account.update(password: newpass, password_confirmation: cnewpass)
      redirect '/profile'
    else
      # Mostramos cualquier error de validación adicional
      @error = @account.errors.full_messages.join(", ")
      erb :modify_password
    end

    redirect '/profile'
  end
end



#Muestra todos los servicios asociados al usuario actual
get '/services' do
  redirect '/login' unless session[:user_id]

  @user = User.find(session[:user_id])
  @account = @user.account

  #Obtiene todos los servicios vinculados a la cuenta
  @services = Service.where(target_account_id: @account.id) 

  erb :services
end

#muestra el formulario para pagar un servicio en particular
get'/services/:id/pay' do
  redirect '/login' unless session[:user_id]

  @service = Service.find(params[:id])
  @user = User.find(session[:user_id])
  @account = @user.account

  #paga el servicio
  erb :pay_service
end

#procesa el pago del servicio
post '/services/:id/pay' do
  redirect '/login' unless session [:user_id]


  service = Service.find(params[:id])
  user = User.find(session[:user_id])
  account = user.account

  begin
    #Intenta pagar desde la cuenta del usuario actual
    transaction = service.pay_from(account)
    redirect '/services'
  rescue => e
    @error = e.message
    @service = service
    @user = user
    @account = account

    erb :pay_service
  end
end