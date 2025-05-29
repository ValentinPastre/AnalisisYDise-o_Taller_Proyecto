class User < ActiveRecord::Base
 
  has_secure_password

  has_one :account
  has_one :security_questions

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end