require_relative 'claseUser'

class Account
  attr_accessor :password, :email, :balance, :cvu, :alias, :securityQuestion, :email
  #ver si SecurityQuestion debe ser una clase propia o clase asociacion
  
  def initialize(password, email, user)
    @password = password
    @email = email
    @balance = 0
    @alias = user.name + "." + user.lastname + ".jp"
    @cvu = cvu_gen
  end

  def change_password(password)
    @password = password
  end

  def change_email(email)
        @email = email
  end

  def change_alias(newalias)
        @alias = newalias
  end

  def cvu_gen
        n = Random.rand
        return (Integer).try_convert(n * (10**15))
  end

  def set_security_question()
        #ver como lo hacemos
  end

  
end


p1 = Person.new(111111, "chicharito", "gomez", 201111116)
a1 = Account.new("GokuMessi2022Qatar", "valentinpastre@jijo.com", p1)

puts "Alias: #{a1.alias}"
puts "CVU: #{a1.cvu}"
puts "Contrasenia: #{a1.password}"

a1.password = "VegettaCR7realMadrid"
puts "Contrasenia: #{a1.password}"
