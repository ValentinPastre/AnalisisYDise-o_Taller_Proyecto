class CreateVirtualDebitCard < ActiveRecord::Migration[8.0]
  def change
    create_table :virtual_debit_cards do |t|
      t.string :card_number, null: false
      t.date :expiration_date, null: false
      t.string :cvv, null: false
      t.string :frontal_id, null: false
      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end
