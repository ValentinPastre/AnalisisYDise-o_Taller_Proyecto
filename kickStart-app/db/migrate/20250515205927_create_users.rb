class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :dni
      t.string :lastname
      t.string :cuil
      t.timestamps
    end
  end
end