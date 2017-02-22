require_relative 'station'
require_relative 'journey'
require_relative 'journey_log'

class Oystercard

  DEFAULT_BALANCE=0
  MAXIMUM_BALANCE=90
  MINIMUM_FARE=1

  attr_reader :balance, :journey_history, :current_journey

  def initialize(set_balance = DEFAULT_BALANCE)
    @balance = set_balance
    @current_journey = Journey.new
    @journey_history = JourneyLog.new
  end

  def top_up(amount)
    raise "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}." if (amount + balance) > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    raise "Insufficient funds" if @balance < MINIMUM_FARE
    fare("entry")
    @current_journey.set_entry_station(station)
  end

  def touch_out(station)
    fare("exit")
    @current_journey.set_exit_station(station)
    save_journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def save_journey
    @journey_history.save(@current_journey)
    # @journey_history << @current_journey
    @current_journey = Journey.new
  end

  def fare(when_called)
    if when_called == "entry" ? check_if_card_touched_out_last_journey : check_if_there_is_an_entry_station
    end
  end

  def check_if_there_is_an_entry_station
     if !!@current_journey.entry_station ? deduct(MINIMUM_FARE) : @balance -= 6
     end
  end

  def check_if_card_touched_out_last_journey
    if @current_journey.entry_station != nil
      @balance -= 6
    end
  end
end
