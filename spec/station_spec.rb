

describe Station do

  it 'should return a station when you call Station.new' do
    expect(Station.new("Shoreditch")).to be_a Station
  end
  
end
