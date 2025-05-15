require_relative 'User'
require_relative 'Movement'
require_relative 'SecurtiyQuestion'

class Account
  attr_accessor :password, :email, :balance, :cvu, :alias, :securityQ, :email
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
        securityQ = SecurityQuestion.new()
        securityQ.set_question
        securityQ.set_answer
        @securityQ = securityQ
  end

end
