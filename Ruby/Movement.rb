require 'date'

class Movement
    attr_accessor :idMovement, :amount, :date #,:tipe

    def initialize(identif)
            @idMovement = identif
            @date = DateTime.now()
    end

    def set_amount(amount)
            @amount = amount
    end

    def transfer_money(account1, account2)
            account1.balance -= @amount
            account2.balance += @amount
    end
end