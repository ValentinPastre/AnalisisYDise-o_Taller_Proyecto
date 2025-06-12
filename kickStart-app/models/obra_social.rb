class ObraSocial < ActiveRecord::Base
  has_many :service
  has_many :notification
  has_many :coverage

  # Sin esto ActiveRecord busca la tabla como ObrasSocials
  self.table_name = 'obras_sociales'
end