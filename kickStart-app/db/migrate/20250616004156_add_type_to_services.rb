class AddTypeToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :type, :string
    #añadir la columna type a services sirve para poder identificar que subclase de servicio es.
    #el servicio puede ser de agua, luz, gas, o transportationCard
  end
end
