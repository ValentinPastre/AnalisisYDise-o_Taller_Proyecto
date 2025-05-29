class ObraSocial < ActiveRecord::Base
  has_many :services
  has_many :notifications
end