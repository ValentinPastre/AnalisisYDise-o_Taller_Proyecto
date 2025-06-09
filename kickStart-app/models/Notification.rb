class Notification < ActiveRecord::Base
  belongs_to :obra_social
  belongs_to :account
end