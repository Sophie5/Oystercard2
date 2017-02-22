require 'journey_log'
# require 'journey'
describe JourneyLog do

  let (:station) {double :station, :name => "Shoreditch", :zone => 1}
  let (:station2) {double :station, :name => "Aldgate East", :zone => 3}



  it 'saves a journey' do
    journey = Journey.new
    journey.set_entry_station(station)
    journey.set_exit_station(station2)
    subject.save(journey)
    expect(subject.journeys).to eq [journey]
  end


end
