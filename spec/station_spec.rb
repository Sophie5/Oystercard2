require 'station'

describe Station do
  subject {Station.new("Shoreditch", 1)}

  it 'should return a station when you call Station.new' do
    expect(subject).to be_a Station
  end

  it 'knows what its name is' do
    expect(subject.name).to eq "Shoreditch"
  end

  it 'knows what zone it is in' do
    expect(subject.zone).to eq 1
  end

end
