class Expiration < ActiveRecord::Base
  belongs_to :service
  enum state: { expired: 0, not_expired: 1 }
end