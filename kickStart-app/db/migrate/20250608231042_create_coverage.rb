class CreateCoverage < ActiveRecord::Migration[8.0]
  def change
    create_table :coverages do |t|
      t.references :obras_sociales, null: false, foreign_key: true
      t.references :services, null: false, foreign_key: true
      t.integer :coverage_percentage
      t.timestamps
    end
  end
end
