class SecurityQuestion < ActiveRecord::Migration[8.0]
  def change
    create_table :security_questions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
