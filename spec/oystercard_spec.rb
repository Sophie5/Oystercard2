require 'oystercard'

describe Oystercard do

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

  describe '#deduct a fare' do

    it 'can deduct value from fare' do
      subject.top_up(20)
      expect {subject.deduct 1 }.to change {subject.balance}.by -1
    end

  end

  describe '#touch_in' do

      it 'changes the status of the card to in use' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in
        expect(subject).to be_in_journey
      end

      it 'raises an error if there are insufficient funds on the card' do
        subject = Oystercard.new(Oystercard::MINIMUM_FARE - 1)
        expect{subject.touch_in}.to raise_error "Insufficient funds"
      end

  end

  describe '#touch_out' do

    it 'changes the status of the card to not in use' do
        subject.top_up(Oystercard::MAXIMUM_BALANCE)
        subject.touch_in
        subject.touch_out
        expect(subject).not_to be_in_journey
    end

  end

  # describe '#in_journey?' do
  #
  #   it 'checks the status of the oystercard after it has been touched in' do
  #       subject.touch_in
  #       expect(subject.in_journey?).to be true
  #   end
  #
  #   it 'checks the status of the oystercard after it has been touched out' do
  #     subject.touch_in
  #     subject.touch_out
  #     expect(subject.in_journey?).to be false
  #   end
  #
  # end

end
