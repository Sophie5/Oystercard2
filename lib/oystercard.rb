require_relative 'station'

class Oystercard

  DEFAULT_BALANCE=0
  MAXIMUM_BALANCE=90
  MINIMUM_FARE=1

  attr_reader :balance, :entry_station, :exit_station, :journey_history

  def initialize(set_balance = DEFAULT_BALANCE)
    @balance = set_balance
    @entry_station = nil
    @exit_station = nil
    @journey_history = []
  end

  def top_up(amount)
    raise "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}." if (amount + balance) > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    raise "Insufficient funds" if @balance < MINIMUM_FARE
    @entry_station = station.name
    @exit_station = nil
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @exit_station = station.name
    save_journey
    @entry_station = nil
  end

  def in_journey?
    !!entry_station
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def save_journey
    recent_journey = Hash.new
    recent_journey = {"Entry Station: " => @entry_station, "Exit Station: " => @exit_station}
    @journey_history << recent_journey
  end

end
