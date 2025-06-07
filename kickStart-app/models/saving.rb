class Saving < ActiveRecord::Base
  belongs_to :account
  #cuando se genere una migracion se necesita una columna account_id como foreign key
end