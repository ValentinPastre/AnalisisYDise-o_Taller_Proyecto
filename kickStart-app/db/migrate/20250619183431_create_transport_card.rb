class CreateTransportCard < ActiveRecord::Migration[8.0]
  def change
    create_table :transport_cards do |t|
      t.integer :number
      t.integer :balance
      
      t.references :transport_company, null: false, foreign_key: true 

      t.timestamps
    end
  end
end
