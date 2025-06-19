class TransportCompany < ActiveRecord::Base
  has_many :transport_cards

  before_save :upcase_name

  private

  def upcase_name
    self.name = name.upcase if name
  end
end