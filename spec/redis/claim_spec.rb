RSpec.describe Redis::Claim do
  it "has a version number" do
    expect(Redis::Claim::VERSION).not_to be nil
  end

  it 'works out of the box' do
    expect { claim_db('test') }.to_not raise_error
  end

  it 'fails when db claimed' do
    claim_db('test1')
    expect { claim_db('test2') }.to raise_error(Redis::Claim::DbAlreadyClaimed)
  end
end

private

def claim_db(app_name)
  Redis::Claim.verify do |config|
    config.redis = REDIS
    config.app_name = app_name
  end
end
