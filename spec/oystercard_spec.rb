require 'oystercard'

describe Oystercard do

let (:station) {double :station, :name => "Shoreditch"}

  it 'has a default balance of zero' do
    expect(Oystercard::DEFAULT_BALANCE).to eq(0)
  end

  describe '#top_up' do

    it 'has a limit' do
      subject.top_up Oystercard::MAXIMUM_BALANCE
      expect { subject.top_up 1 }.to raise_error "Failed! Your card limit is #{Oystercard::MAXIMUM_BALANCE}."
    end

    it 'can top up the balance' do
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

  end

  describe '#touch_in' do

      it 'changes the status of the card to in use' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(station)
        expect(subject).to be_in_journey
      end

      it 'raises an error if there are insufficient funds on the card' do
        subject = Oystercard.new(Oystercard::MINIMUM_FARE - 1)
        expect{subject.touch_in(station)}.to raise_error "Insufficient funds"
      end

      it 'saves the station that the card touch in at' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(station)
        expect(subject.entry_station).to eq station.name
      end
  end

  describe '#touch_out' do

    it 'changes the status of the card to not in use' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in(station)
        subject.touch_out
        expect(subject).not_to be_in_journey
    end

    it 'changes the balance of Oystercard by the minimum fare' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(station)
      expect { subject.touch_out }.to change { subject.balance }.by(- Oystercard::MINIMUM_FARE)
    end

    it 'forgets the station that the card touch in at when you touch out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(station)
      subject.touch_out
      expect(subject.entry_station).to eq nil
    end
  end

end
