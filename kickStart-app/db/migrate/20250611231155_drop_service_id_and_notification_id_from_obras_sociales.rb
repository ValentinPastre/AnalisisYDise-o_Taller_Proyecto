class DropServiceIdAndNotificationIdFromObrasSociales < ActiveRecord::Migration[8.0]
  def change
    remove_column :obras_sociales, :services_id, :integer
    remove_column :obras_sociales, :notifications_id, :integer
  end
end
