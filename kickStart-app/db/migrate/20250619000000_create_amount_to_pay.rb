class CreateAmountToPay < ActiveRecord::Migration[6.0]
  def change
    create_table :amount_to_pay do |t|
      t.string :service_name
      t.string :tipo_pago
      t.integer :amount_cents, default: 0, null: false
      t.date :due_date
      t.boolean :paid, default: false, null: false
      t.boolean :expired, default: false, null: false
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
