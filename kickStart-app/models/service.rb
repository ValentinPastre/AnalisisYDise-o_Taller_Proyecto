class Service < ActiveRecord::Base

  has_many :expirations
  has_one :obra_social
  has_one :expiration
end