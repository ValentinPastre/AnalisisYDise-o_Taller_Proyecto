class Service
    attr_accessor :id_service, :amount_to_pay

    def initialize(id_service, amount_to_pay)
      @id_service = id_service
      @amount_to_pay = amount_to_pay
    end

