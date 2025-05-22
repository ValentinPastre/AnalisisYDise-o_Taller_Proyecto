class User < ActiveRecord::Base
  # Relationships
  has_one :account

  # Validations
  validates :name, presence: true
end