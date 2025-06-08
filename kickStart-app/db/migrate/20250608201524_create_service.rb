class CreateService < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      #t.references :account, null: false, foreign_key: {to_table: :accounts}
      t.references :obras_sociales, null: true, foreign_key: true
      t.references :transactions, null: true, foreign_key: true
      t.integer :amount_to_pay
      t.timestamps
    end
  end
end