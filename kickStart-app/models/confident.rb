class Confident < ActiveRecord::Base
  belongs_to :account
  belongs_to :transaction
end