class User
    attr_accessor :dni, :name, :lastname, :cuil
  
    def initialize(dni, name, lastname, cuil)
      @dni = dni
      @name = name
      @lastname = lastname
      @cuil = cuil
    end
end