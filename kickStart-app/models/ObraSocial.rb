class ObraSocial < ActiveRecord::Base
  belongs_to :service
  has_many :service
  has_many :notification
end