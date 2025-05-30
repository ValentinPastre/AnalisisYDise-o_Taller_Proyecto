class AddTypeToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :service, :type, :string
  end
end
#guarda automáticamente el nombre de la subclase (ej: Agua) en la columna type cuando crees una instancia de esa clase.