require_relative 'claseAccount'

Class Movement
  attr_accessor :IDMovement, :Amount, :Tipe, :Date

  def initialize(id)
        @IDMovement = id
  end

