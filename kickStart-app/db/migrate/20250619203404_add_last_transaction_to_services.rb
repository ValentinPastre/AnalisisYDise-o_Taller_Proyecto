class AddLastTransactionToServices < ActiveRecord::Migration[8.0]
  def change
    add_reference :services, :last_transaction, foreign_key: { to_table: :transactions }
  end
end
