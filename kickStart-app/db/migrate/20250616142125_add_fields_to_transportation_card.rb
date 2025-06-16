class AddFieldsToTransportationCard < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :number, :string
    #number, es un string
    add_column :services, :balance, :decimal, precision: 10, scale: 2
    #balance, es un numero decimal con hasta 10 digitos totales y 2 decimales 
    #(por ejemplo, 9999999999.99)

    #Lamentablemente todas las subclases de service van a tener number y balance
    #En agua, luz y gas va a haber number y balance
    #Tenemos que ser concientes de que es un campo vacio en esos 3

    #por ejemplo:
    #agua = Agua.new
    #agua.number #=> nil (existe como atributo, pero no tiene sentido)
    #Esto no rompe nada, pero si "ensucia" la tabla
    #va a tener datos irrevelantes para muchas subclases
  end
end
