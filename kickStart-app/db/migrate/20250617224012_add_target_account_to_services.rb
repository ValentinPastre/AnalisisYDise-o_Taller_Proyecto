class AddTargetAccountToServices < ActiveRecord::Migration[8.0]
  def change
    #Agregamos un campo, target_account

    add_reference :services, :target_account, foreing_key: {to_table: :accounts}
    #foreing_key, crea una asociacion hacia la tabla accounts, no a una tabla target_accounts
    #nos sirve para saber cual es la cuenta de destino del pago

end
