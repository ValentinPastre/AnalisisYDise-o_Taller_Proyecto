class ModifyUsers2 < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email, :string
  end
end
