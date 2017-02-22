require 'oystercard'

describe Oystercard do

  let (:station) {double :station, :name => "Shoreditch", :zone => 1}
  let (:station2) {double :station, :name => "Aldgate East", :zone => 3}

  before(:each) do
    journey = Journey.new
    journey.set_entry_station(station)
    journey.set_exit_station(station2)
    subject.journey_history.save(journey)
    subject.top_up(Oystercard::MAXIMUM_BALANCE)
  end

  it 'has a default balance of zero' do
    expect(Oystercard::DEFAULT_BALANCE).to eq(0)
  end

  describe '#top_up' do

    it 'has a limit', :tag do
      expect { subject.top_up 1 }.to raise_error "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}."
    end

    it 'can top up the balance' do
      subject = Oystercard.new
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

  end

  describe '#touch_in' do

      it 'raises an error if there are insufficient funds on the card' do
        subject = Oystercard.new(Oystercard::MINIMUM_FARE - 1)
        expect{subject.touch_in(station)}.to raise_error "Insufficient funds"
      end

      it 'saves the station that the card touch in at' do
        subject.touch_in(station)
        expect(subject.current_journey.entry_station).to eq station
      end
  end

  describe '#touch_out' do

    it 'changes the status of the card to not in use' do
        subject.touch_in(station)
        subject.touch_out(station2)
        expect(subject.current_journey.in_journey?).to be false
    end

    it 'changes the balance of Oystercard by the minimum fare' do
      subject.touch_in(station)
      expect { subject.touch_out(station2) }.to change { subject.balance }.by(- Oystercard::MINIMUM_FARE)
    end

    it 'forgets the station that the card touch in at when you touch out' do
      subject.touch_in(station)
      subject.touch_out(station2)
      expect(subject.current_journey.entry_station).to eq nil
    end

    it 'saves the station that the card touches out at ' do
      subject.touch_in(station)
      subject.touch_out(station2)
      expect(subject.journey_history.journeys[0].exit_station).to eq station2
    end

    it 'saves recent journey into a journey history array' do
      subject.touch_in(station)
      journey = subject.current_journey
      subject.touch_out(station2)
      journey.set_exit_station(station2)
      expect(subject.journey_history.journeys[1]).to eq journey
    end
  end

  describe '#fare' do

    it 'deducts the penalty fare if user touches out without touching in' do
      subject.touch_out(station)
      expect(subject.balance).to eq(Oystercard::MAXIMUM_BALANCE - 6)
    end

    it 'deducts the penalty fare if the user touches in without touching out from their last journey' do
      subject.touch_in(station)
      subject.touch_in(station2)
      expect(subject.balance).to eq(Oystercard::MAXIMUM_BALANCE - 6)
    end
  end

end
