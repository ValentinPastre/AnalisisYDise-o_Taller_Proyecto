class Service < ActiveRecord::Base
  has_many :coverage
  has_many :expiration
  has_one :obra_social
  belongs_to :target_account, class_name: 'Account', optional: true #cuenta que cobra el servicio
  belongs_to :last_transaction, class_name: 'Transaction', optional: true
  has_many :transactions
  has_one :amount_to_pay, -> { order(created_at: :desc) }




  def amount_to_pay_cents
    amount_to_pay&.total_to_pay || 0
  end

  #Metodo principal para pagar un servicio desde una cuenta de origen
  def pay_from (source_account)
    #validaciones previas
    raise ArgumentError, "Este servicio no tiene una cuenta destino" unless target_account
    raise "Este servicio ya fue pagado" if already_paid?
    raise ArgumentError, "No tiene suficiente dinero para pagar el servicio" unless payable_by?(source_account)

    #si pasa las validaciones crea una transaccion
    tx = Transaction.create!(
      source_account: source_account,
      target_account: target_account,
      amount: amount_to_pay_cents
    )

    #guarda la transaccion como la ultima asociada al servicio
    update!(last_transaction: tx)
    tx
  end

  #devuelve true si el servicio fue pagado
  def already_paid?
    #Logica de si fue pagado o no
    last_transaction && last_transaction.amount == amount_to_pay_cents
  end

  #indica si una cuenta tiene saldo suficiente para pagar el servicio
  def payable_by?(account)
    puts "Saldo de cuenta: #{account.balance}"
    puts "Monto a pagar: #{amount_to_pay_cents}"
    account.balance >= amount_to_pay_cents
  end
end
