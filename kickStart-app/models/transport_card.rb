class TransportCard < ActiveRecord::Base
  belongs_to :transport_company
  belongs_to :user, optional: true

  validates :number, presence: true, uniqueness: true

  before_validation :generate_card_number, on: :create

  private 

  def generate_card_number
    self.number ||= loop do
      n = Array.new(12) { rand(0..9) }.join
      break n unless TransportCard.exists?(number: n)
    end
  end
end