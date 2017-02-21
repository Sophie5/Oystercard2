require 'oystercard'

describe Oystercard do

  before(:each) do
    subject.top_up(Oystercard::MAXIMUM_BALANCE)
  end

  let (:station) {double :station, :name => "Shoreditch"}
  let (:station2) {double :station, :name => "Aldgate East"}

  it 'has a default balance of zero' do
    expect(Oystercard::DEFAULT_BALANCE).to eq(0)
  end

  describe '#top_up' do

    it 'has a limit' do
      expect { subject.top_up 1 }.to raise_error "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}."
    end

    it 'can top up the balance' do
      subject = Oystercard.new
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

  end

  describe '#touch_in' do

      it 'changes the status of the card to in use' do
        subject.touch_in(station)
        expect(subject).to be_in_journey
      end

      it 'raises an error if there are insufficient funds on the card' do
        subject = Oystercard.new(Oystercard::MINIMUM_FARE - 1)
        expect{subject.touch_in(station)}.to raise_error "Insufficient funds"
      end

      it 'saves the station that the card touch in at' do
        subject.touch_in(station)
        expect(subject.entry_station).to eq station.name
      end
  end

  describe '#touch_out' do

    it 'changes the status of the card to not in use' do
        subject.touch_in(station)
        subject.touch_out(station2)
        expect(subject).not_to be_in_journey
    end

    it 'changes the balance of Oystercard by the minimum fare' do
      subject.touch_in(station)
      expect { subject.touch_out(station2) }.to change { subject.balance }.by(- Oystercard::MINIMUM_FARE)
    end

    it 'forgets the station that the card touch in at when you touch out' do
      subject.touch_in(station)
      subject.touch_out(station2)
      expect(subject.entry_station).to eq nil
    end

    it 'saves the station that the card touches out at ' do
      subject.touch_in(station)
      subject.touch_out(station2)
      expect(subject.exit_station).to eq station2.name
    end

    it 'saves recent journey into a journey history array' do
      subject.touch_in(station)
      subject.touch_out(station2)
      expect(subject.journey_history).to eq [{"Entry Station: " => "Shoreditch", "Exit Station: " => "Aldgate East"}]
    end
  end

end
