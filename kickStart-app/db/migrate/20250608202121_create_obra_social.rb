class CreateObraSocial < ActiveRecord::Migration[8.0]
  def change
    create_table :obras_sociales do |t|
      t.references :services, null: true, foreign_key: false
      #pongo null: true porque puede ser que la obra social no te cubra ningun servicio
      t.references :users, null: true, foreign_key: true
      t.references :notifications, null: true, foreign_key: false #falta crear la migracion notifications
      t.string :name
      t.timestamps
    end
  end
end
