
require_relative 'journey'

class JourneyLog

attr_reader :journeys

  def initialize
    @journeys = []
  end

  def save(journey)
    @journeys << journey
  end
end
