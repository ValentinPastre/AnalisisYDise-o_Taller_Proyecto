class RemoveColumnsFromUsers2 < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :cuil, :integer
  end
end
