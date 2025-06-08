class AddStateToExpiration < ActiveRecord::Migration[8.0]
  def change
    add_column :expirations, :state, :integer, default: 1, null: false
  end
end
