class Redis
  class Claim
    class Configuration
      LOCK_KEY_NAME = "redis-claim:app"
      # Required attributes
      attr_accessor :redis, :app_name
      # Optional attributes
      attr_accessor :ignore_connection_error, :lock_key

      def initialize
        self.lock_key = LOCK_KEY_NAME
        self.ignore_connection_error = false
      end
    end
  end
end
