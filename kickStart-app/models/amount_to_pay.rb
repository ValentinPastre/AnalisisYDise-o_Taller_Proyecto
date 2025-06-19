require 'active_record'
require 'date'

class AmountToPay < ActiveRecord::Base
  belongs_to :service
  self.table_name = 'amount_to_pay'

  SERVICES = {
    "Luz" => 14,
    "Gas" => 16,
    "Agua" => 10
  }

  before_create :set_due_date_and_amount
  before_save :update_expired_status

  def set_due_date_and_amount
    day = SERVICES[service_name]
    raise "Servicio inválido" unless day

    today = Date.today

    monto_mensual = rand(5000..50000) # en centavos
    self.amount_cents = tipo_pago == "Anual" ? monto_mensual * 12 : monto_mensual

    self.due_date = Date.new(today.year, today.month, day)
  end

  def update_expired_status
    if due_date.is_a?(Date)
      self.expired = !paid && Date.today > due_date
    else
      self.expired = false
    end
  end

  def total_to_pay
    expired ? (amount_cents * 1.05).to_i : amount_cents
  end
end
