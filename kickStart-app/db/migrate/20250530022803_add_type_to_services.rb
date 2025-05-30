class AddTypeToServices < ActiveRecord::Migration[8.0]
  def change
    add_column :services, :type, :string
  end
end
