#Subclase TransportationCard de Service
class TransportationCard < Service

  attr_accessor :number, :balance

  def initialize(id_service, balance)
    super(id_service, amount_to_pay)
    @number = number
    @balance = balance
  end
  
end