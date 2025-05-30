class AddColumnsToUsers2 < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :dni, :integer
    add_column :users, :cuil, :integer
    add_column :users, :lastname, :string
  end
end
