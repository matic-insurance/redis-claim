RSpec.describe Redis::Claim::Configuration do
  let(:config) { described_class.new }

  context 'default values' do
    it 'has no redis' do
      expect(config.redis).to eq(nil)
    end

    it 'has no app_name' do
      expect(config.app_name).to eq(nil)
    end

    it 'does not ignore connection value' do
      expect(config.ignore_connection_error).to be_falsey
    end

    it 'has default lock key' do
      expect(config.lock_key).to eq("redis-claim:app")
    end
  end
end
