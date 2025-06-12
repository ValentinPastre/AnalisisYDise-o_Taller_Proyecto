class ObraSocial < ActiveRecord::Base
  has_many :service
  has_many :notification
  has_many :coverage

  # Sin esto ActiveRecord busca la tabla como ObrasSocials
  self.table_name = 'obras_sociales'

  # Para guardar el nombre de la obra social en mayúsculas
  before_save :upcase_name

  private

  def upcase_name
    self.name = name.upcase if name
  end
end