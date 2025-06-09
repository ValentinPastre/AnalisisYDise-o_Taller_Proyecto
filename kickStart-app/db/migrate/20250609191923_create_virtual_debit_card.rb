class CreateVirtualDebitCard < ActiveRecord::Migration[8.0]
  def change
    create_table :virtual_debit_cards do |t|
      t.references :accounts, null: false, foreign_key: true
      #deberia de hacer un t.references :virtual_debit_cards en account?
      t.integer :card_number
      t.integer :security_code
      t.date :expiration
      t.timestamps
    end
  end
end
