class Redis
  class Claim
    class Error < StandardError; end
    class InvalidConfiguration < Error; end
    class DbAlreadyClaimed < Error; end
  end
end