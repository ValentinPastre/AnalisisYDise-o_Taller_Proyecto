class AddColumnToServices < ActiveRecord::Migration[6.0]
  def change
    add_column :services, :service_name, :string
    add_column :services, :amount_cents, :integer, default: 0, null: false
    add_column :services, :due_date, :date
    add_column :services, :expired, :boolean, default: false, null: false
    add_column :services, :paid, :boolean, default: false, null: false
    add_column :services, :tipo_pago, :string, default: "Mensual";
  end
end
