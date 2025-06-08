class Account < ActiveRecord::Base
  belongs_to :user
  has_one :security_questions
  has_many :source_transactions, class_name: 'Transaction', foreign_key: :source_account_id
  has_many :savings, class_name: 'Saving'
end