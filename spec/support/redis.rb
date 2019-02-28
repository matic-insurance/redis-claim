REDIS = Redis.new

RSpec.configure do |config|
  config.after(:each) do
    REDIS.flushdb
  end
end
