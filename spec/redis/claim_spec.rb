RSpec.describe Redis::Claim do
  it "has a version number" do
    expect(Redis::Claim::VERSION).not_to be nil
  end

  it 'works out of the box' do
    expect { claim_db }.to_not raise_error
  end

  it 'fails when db claimed' do
    REDIS.set('redis-claim::app', 'app')
    expect(&method(:claim_db)).to raise_error
  end
end

private

def claim_db
  Redis::Claim.verify do |config|
    config.redis = REDIS
    config.app_name = APP_NAME
  end
end
