class Oystercard

  DEFAULT_BALANCE=0

  attr_reader :balance

  def initialize(set_balance = DEFAULT_BALANCE)
    @balance = set_balance
  end

end
