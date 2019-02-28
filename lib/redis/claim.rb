require "redis/claim/version"
require "redis/claim/configuration"
require "redis/claim/actions"
require "redis/claim/errors"

class Redis
  class Claim
    def self.verify(&configurator)
      config = Redis::Claim::Configuration.new.tap(&configurator)
      Redis::Claim::Actions.claim_db!(config)
    end
  end
end
