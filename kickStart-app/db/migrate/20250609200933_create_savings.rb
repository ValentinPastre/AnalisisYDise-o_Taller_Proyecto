class CreateSavings < ActiveRecord::Migration[8.0]
  def change
    create_table :savings do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :description, null: false

      t.timestamps # Automaticane crea created_at y updated_at 
    end

    add_index :savings, [:account_id, :created_at]
  end
end
