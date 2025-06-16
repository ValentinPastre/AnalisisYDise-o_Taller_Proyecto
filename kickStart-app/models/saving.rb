class Saving < ActiveRecord::Base
  belongs_to :account
  
  validate :has_enough_balance, on: :create
  validate :valid_amount, on: :update
  
  after_create :lock_amount
  before_destroy :return_amount

  def add_amount(additional_amount)
    ActiveRecord::Base.transaction do
      if account.balance >= additional_amount.to_f
        self.amount += additional_amount.to_f
        account.balance -= additional_amount.to_f
        save!
        account.save!
      else
        errors.add(:amount, "No tiene suficiente saldo para agregar a este ahorro")
        false
      end
    end
  end

  # ... (mantén los demás métodos existentes)

  private

  def valid_amount
    if amount.to_f <= 0
      errors.add(:amount, "El monto debe ser mayor a cero")
    end
  end

  def return_to_account
    ActiveRecord::Base.transaction do
      account.balance += amount
      account.save!
      destroy!
    end
  end

  private

  def lock_amount
    ActiveRecord::Base.transaction do
      account.balance -= amount
      account.save!
    end
  end

  def return_amount
    ActiveRecord::Base.transaction do
      account.balance += amount
      account.save!
    end
  end

  def has_enough_balance
    if account.balance < amount.to_f
      errors.add(:amount, "No tiene suficiente saldo para realizar este ahorro")
    end
  end
end