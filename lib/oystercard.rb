require_relative 'station'

class Oystercard

  DEFAULT_BALANCE=0
  MAXIMUM_BALANCE=90
  MINIMUM_FARE=1

  attr_reader :balance, :entry_station

  def initialize(set_balance = DEFAULT_BALANCE)
    @balance = set_balance
    @entry_station = nil
  end

  def top_up(amount)
    raise "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}." if (amount + balance) > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    raise "Insufficient funds" if @balance < MINIMUM_FARE
    @entry_station = station.name
  end

  def touch_out
    deduct(MINIMUM_FARE)
    @entry_station = nil
  end

  def in_journey?
    !!entry_station
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
