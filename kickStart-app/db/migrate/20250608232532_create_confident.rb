class CreateConfident < ActiveRecord::Migration[8.0]
  def change
    create_table :confidents do |t|
      t.references :account, null: false, foreign_key: true
      t.string :email
      t.timestamps
    end
  end
end
