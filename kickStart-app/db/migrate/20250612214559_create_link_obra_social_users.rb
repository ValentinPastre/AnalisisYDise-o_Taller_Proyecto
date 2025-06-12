class CreateLinkObraSocialUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :links_obra_social_user do |t|
      t.references :obras_sociales, null: false, foreign_key: true
      t.references :users, null: false, foreign_key: true
      t.integer :credential
      t.timestamps
    end
  end
end
