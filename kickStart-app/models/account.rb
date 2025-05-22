class Account < ActiveRecord::Base
  belongs_to :user
  has_many :source_transactions, class_name: 'Transaction', foreign_key: :source_account_id
end