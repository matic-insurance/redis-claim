class Redis
  class Claim
    class Actions
      extend Forwardable

      attr_reader :config

      delegate redis: :config, app_name: :config, lock_key: :config

      def initialize(config)
        @config = config
      end

      def self.claim_db!(config)
        actions = self.new(config)
        actions.verify_connection!
        actions.verify_connection!
        actions.claim_db!
      end

      def verify_config!
        raise Redis::Claim::InvalidConfiguration, 'app name is missing' unless app_name
        raise Redis::Claim::InvalidConfiguration, 'redis is missing' unless redis
        raise Redis::Claim::InvalidConfiguration, 'redis should respond to ping' unless redis.respond_to?(:ping)
        raise Redis::Claim::InvalidConfiguration, 'redis should respond to setnx' unless redis.respond_to?(:setnx)

        true
      end

      def verify_connection!
        return true if config.ignore_connection_error

        redis.ping
      end

      def claim_db!
        return true if redis.setnx(lock_key, app_name)
        return true if redis.get(lock_key) == app_name

        raise Redis::Claim::DbAlreadyClaimed, "database already claimed by #{redis.get(lock_key)}"
      end
    end
  end
end
