RSpec.describe Redis::Claim do
  it "has a version number" do
    expect(Redis::Claim::VERSION).not_to be nil
  end

  it 'works out of the box' do
    expect { Redis::Claim.verify }.to_not raise_error
  end
end
