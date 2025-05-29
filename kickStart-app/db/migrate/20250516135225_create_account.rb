class CreateAccount < ActiveRecord::Migration[8.0]
  def change

    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.integer :balance, default: 0
      t.string :password_digest
      t.string :cvu
      t.string :alias
      t.string :email
      t.timestamps
    end
  end
end