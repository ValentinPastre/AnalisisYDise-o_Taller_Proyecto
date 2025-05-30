class ModifyUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :cuil, :integer
    remove_column :users, :email, :string
  end
end
