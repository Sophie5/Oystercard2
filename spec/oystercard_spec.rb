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


end
