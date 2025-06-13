class User < ActiveRecord::Base
 
  has_one :account
  has_one :security_questions

  validates :name, presence: true
  validates :dni, uniqueness: true
  validates :cuil, uniqueness: true
end