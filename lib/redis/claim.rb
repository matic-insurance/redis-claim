require "redis/claim/version"

module Redis
  module Claim
    class Error < StandardError; end
    # Your code goes here...
    def self.verify
      true
    end
  end
end
