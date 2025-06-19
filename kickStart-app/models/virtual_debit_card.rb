# models/virtual_debit_card.rb
class VirtualDebitCard < ActiveRecord::Base
  belongs_to :account
  validates :card_number, uniqueness: true
  before_create :generate_card_details

  private

  def generate_card_details
    # Generar número de tarjeta (16 dígitos)
    self.card_number = Array.new(16) { rand(0..9) }.join
    
    # Generar fecha de vencimiento (3 años en el futuro)
    self.expiration_date = Date.today + 3.years
    
    # Generar CVV (3 dígitos)
    self.cvv = Array.new(3) { rand(0..9) }.join
    
    # Generar número frontal único
    self.frontal_id = "VDC-#{Array.new(6) { rand(0..9) }.join}"
  end
end