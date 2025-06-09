class CreateVirtualDebitCard < ActiveRecord::Migration[8.0]
  def change
    create_table :virtual_debit_cards do |t|
      t.references :account, null: false, foreign_key: true
      #deberia de hacer un t.references :virtual_debit_cards en account?
      t.string :card_number, null: false
      t.integer :security_code, null: false
      t.date :expiration, null: false
      t.timestamps
    end
  end
end
