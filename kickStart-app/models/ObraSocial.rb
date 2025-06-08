class ObraSocial < ActiveRecord::Base
  has_many :service
  has_many :notification
  has_many :coverage
end