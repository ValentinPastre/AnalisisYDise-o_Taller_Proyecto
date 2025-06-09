class VirtualDebitCard < ActiveRecord::Base
  belongs_to :account

  validates :card_number, uniqueness: true
end