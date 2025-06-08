class Service < ActiveRecord::Base
  has_many :coverage
  has_many :expiration
  has_one :obra_social
end