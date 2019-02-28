RSpec.describe Redis::Claim::Actions do
  let(:config) { Redis::Claim::Configuration.new }
  let(:actions) { described_class.new(config) }

  before { config.app_name = 'test' }
  before { config.redis = REDIS }

  describe 'verify_configuration!' do
    it 'raises error when redis missing' do
      config.redis = nil
      expect { actions.verify_config! }.to raise_error(Redis::Claim::InvalidConfiguration)
    end

    it 'raises error when redis doesnt have get method' do
      config.redis = double('fake redis', setnx: true)
      expect { actions.verify_config! }.to raise_error(Redis::Claim::InvalidConfiguration)
    end

    it 'raises error when redis doesnt have setnx method' do
      config.redis = double('fake redis', get: 'test')
      expect { actions.verify_config! }.to raise_error(Redis::Claim::InvalidConfiguration)
    end

    it 'raises error when app name missing' do
      config.app_name = nil
      expect { actions.verify_config! }.to raise_error(Redis::Claim::InvalidConfiguration)
    end

    it 'works with all values configured' do
      expect { actions.verify_config! }.not_to raise_error
    end
  end

  describe 'claim_db!' do
    context 'without connection' do
      before { allow(config.redis).to receive(:setnx).and_raise('no connection') }

      it 'passes when ignoring connection errors' do
        config.ignore_connection_error = true
        expect { actions.claim_db! }.not_to raise_error
      end

      it 'fails' do
        expect { actions.claim_db! }.to raise_error('no connection')
      end
    end

    it 'passes when db is not owned' do
      expect { actions.claim_db! }.not_to raise_error
    end

    it 'passes when owned by same app' do
      actions.claim_db!
      expect { actions.claim_db! }.not_to raise_error
    end

    it 'fails when owned by another app' do
      actions.claim_db!
      config.app_name = 'new app'
      expect { actions.claim_db! }.to raise_error(Redis::Claim::DbAlreadyClaimed)
    end
  end
end
