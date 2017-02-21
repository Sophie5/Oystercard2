class Oystercard

  DEFAULT_BALANCE=0
  MAXIMUM_BALANCE=90
  MINIMUM_FARE=1

  attr_reader :balance, :in_journey

  def initialize(set_balance = DEFAULT_BALANCE)
    @balance = set_balance
    @in_journey = false
  end

  def top_up(amount)
    raise "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}." if (amount + balance) > MAXIMUM_BALANCE
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    raise "Insufficient funds" if @balance < MINIMUM_FARE
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

end
