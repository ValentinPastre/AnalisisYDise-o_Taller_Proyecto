class Transaction < ActiveRecord::Base
  belongs_to :source_account, class_name: 'Account'
  belongs_to :target_account, class_name: 'Account'
  has_many :confident

  validate :has_enough_balance, on: :create
  
  after_create :transfer_balance

  private

  def transfer_balance
    # Hacer todo en una transacción de DB para evitar inconsistencias
    ActiveRecord::Base.transaction do
      source_account.balance -= amount
      source_account.save!

      target_account.balance += amount
      target_account.save!
    end
  end

  def has_enough_balance
    if source_account.balance < amount
      errors.add(:amount, "No tiene suficiente balance para realizar el movimiento")
    else
    end
  end
end