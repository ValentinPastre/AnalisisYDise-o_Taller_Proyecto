class CreateExpiration < ActiveRecord::Migration[8.0]
  def change
    create_table :expirations do |t|
      t.references :services, null: false, foreign_key: true
      t.integer :recharge_percentage
      t.date :date
      t.timestamps
    end
  end
end
