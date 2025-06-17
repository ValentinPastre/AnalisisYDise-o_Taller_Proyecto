class Service < ActiveRecord::Base
  has_many :coverage
  has_many :expiration
  has_one :obra_social
  belongs_to :target_account, class_name: ´Account´, optional: true
  has_many :transactions

  def pay_from (source_account)
    raise "Este servicio no tiene una cuenta destino" unless target_account
    raise "Este servicio ya fue pagado" if already_paid?
    raise "No tiene suficiente dinero para pagar el servicio" if payable_by?

    tx = Transaction.create!(
      source_account: source_account,
      target_account: target_account,
      amount: amount_to_pay
    )

    update!(last_transaction: tx)
    tx
  end

  def already_paid?
    #Logica de si fue pagado o no
  end

  def payable_by?(account)
    account.balance >= amount_to_pay
  end
end