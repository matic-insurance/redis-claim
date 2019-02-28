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
        actions.verify_config!
        actions.verify_connection!
        actions.claim_db!
      end

      def verify_config!
        check_config_values!
        check_redis_functionality!

        true
      end

      def verify_connection!
        return true if config.ignore_connection_error

        redis.ping
      end

      def claim_db!
        current_lock = get_db_lock
        if app_name == current_lock
          true
        else
          raise Redis::Claim::DbAlreadyClaimed, "database already claimed by #{current_lock}"
        end
      end

      protected

      def check_config_values!
        return raise_configuration_error('app name is missing') unless app_name
        return raise_configuration_error('redis is missing') unless redis

        true
      end

      def check_redis_functionality!
        return raise_configuration_error('redis should respond to ping') unless redis.respond_to?(:ping)
        return raise_configuration_error('redis should respond to setnx') unless redis.respond_to?(:setnx)

        true
      end

      def get_db_lock
        return app_name if redis.setnx(lock_key, app_name)
        redis.get(lock_key)
      rescue => e
        return app_name if config.ignore_connection_error
        raise e
      end

      def raise_configuration_error(message)
        raise Redis::Claim::InvalidConfiguration, message
      end
    end
  end
end
