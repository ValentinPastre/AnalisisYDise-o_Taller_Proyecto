class Service < ActiveRecord::Base

  has_many :expirations
  belongs_to :obra_social
  
end