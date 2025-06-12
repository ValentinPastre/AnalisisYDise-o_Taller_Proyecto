class DropColumnFromObraSocial < ActiveRecord::Migration[8.0]
  def change
    remove_column :obras_sociales, :users_id, :integer
  end
end
