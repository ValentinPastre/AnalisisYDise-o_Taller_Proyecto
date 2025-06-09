class Saving < ActiveRecord::Base
  belongs_to :account
  
  validate :has_enough_balance, on: :create
  
  after_create :lock_amount
  before_destroy :return_amount

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