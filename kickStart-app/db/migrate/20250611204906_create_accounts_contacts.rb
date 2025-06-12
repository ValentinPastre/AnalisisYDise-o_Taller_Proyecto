class CreateAccountsContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts_contacts, id: false do |t|
      t.integer :account_id, null: false, index: false
      t.integer :contact_id, null: false, index: false
    end

    add_index :accounts_contacts, [:account_id, :contact_id], unique: true
    add_foreign_key :accounts_contacts, :accounts, column: :account_id
    add_foreign_key :accounts_contacts, :accounts, column: :contact_id
  end
end
