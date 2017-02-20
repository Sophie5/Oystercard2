class Oystercard

  DEFAULT_BALANCE=0
  MAXIMUM_BALANCE=90

  attr_reader :balance

  def initialize(set_balance = DEFAULT_BALANCE)
    @balance = set_balance
  end

  def top_up(amount)
    raise "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}." if (amount + balance) > MAXIMUM_BALANCE
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

end
