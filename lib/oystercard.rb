require_relative 'journey'
require_relative 'station'

class Oystercard
  MAX_BALANCE = 90
  MIN_FARE = 1
  MIN_AMOUNT = 1

  attr_reader :balance
  attr_reader :journey
  attr_reader :journeys

  def initialize
    @balance = 0
    @journeys = []
    new_journey
  end

  def top_up(amount)
    raise "Maximum balance of £#{MAX_BALANCE} exceeded" if (@balance + amount) > MAX_BALANCE
    @balance += amount
  end

  def touch_in(entry_station)
    raise "Card needs at least £#{MIN_AMOUNT} to touch in" if @balance < MIN_AMOUNT
    @journey.start_journey(entry_station)
  end

  def touch_out(exit_station)
    @journey.end_journey(exit_station)
    deduct_fare
    store_journey
  end

  def in_journey?
    return false if @journey.nil?
    @journey.in_journey?
  end

  def store_journey
    @journeys << @journey
    new_journey
  end

  private

  def new_journey
    @journey = Journey.new
  end

  def deduct_fare
    @balance -= @journey.fare
  end
end
