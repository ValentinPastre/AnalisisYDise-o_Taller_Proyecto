class CreateNotification < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :obras_sociales, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.integer :discount
      t.string :product
      t.date :promo_end_date

      t.timestamps 
    end
  end
end
