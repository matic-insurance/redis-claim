# Redis::Claim

[![Build Status](https://travis-ci.org/matic-insurance/redis-claim.svg?branch=master)](https://travis-ci.org/matic-insurance/redis-claim)
[![Test Coverage](https://api.codeclimate.com/v1/badges/489ff6577678a8d2a868/test_coverage)](https://codeclimate.com/github/matic-insurance/redis-claim/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/489ff6577678a8d2a868/maintainability)](https://codeclimate.com/github/matic-insurance/redis-claim/maintainability)

Prevent conflicts of several apps using same Redis database or namespace. 
Allows to check if db is already taken and claim ownership of the db.

Common use case for the gem is microservices that share single physical redis instance. 
In such case it is common problem to make an error in redis url, or namespace. 
When passing redis url to the app it is very to make mistake in redis database number.   

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis-claim'
```

## Usage

Assuming you have redis you want to claim
```ruby
REDIS = Redis.new(url: "redis://redis-instance.aws.com:6379/12")
```

On the start of your application execute following code. 

```ruby
Redis::Claim.verify do |config|
  # Your redis instance you want to claim
  config.redis = REDIS      
  # Application name to detect any other service that claimed db  
  config.app_name = 'my cool application'
end
```

An `Redis::Claim::Error` will be raised in case of configuration or claim error 

**NOTE** For rails you can add this code to custom initializer `redis_claim.rb` in `app/config/initializers`

## Behaviour

Redis Claim has following execution steps

1. Executed only once on start of the application. 
1. Checks connection to redis by calling `ping` command
1. Sets lock key if it does not exist with `setnx` command
1. Reads lock key if it exists and compares to `app_name`
1. Checks if existing lock key is the same as `app_name`

**IMPORTANT** Redis claim will not detect db conflict if another application/service is not using it

## Configuration options

When executing `Redis::Claim.verify` - passed block will receive configuraiton object with following properties: 

| Parameter               | Format  | Required | Description                                                                                         |
|-------------------------|---------|----------|-----------------------------------------------------------------------------------------------------|
| redis                   | Object  | true     | Initialized Redis. Work with any object as long as it responds to `ping`, `get` and `setnx` methods |
| app_name                | String  | true     | Name of your application. Should be uniuq for every microservice.                                   |
| ignore_connection_error | Boolean | false    | Do not raise exception when cannot connect to Redis. Default: **false**                             |
| lock_key                | String  | false    | Name of the redis key where lock identifier will be recorded. Default: **'redis-claim:app'**        |

## Development

1. [Install Redis](https://redis.io//download)
1. Run `bin/setup` to install dependencies
1. Run tests `rspec`
1. Add new test
1. Add new code
1. Go to step 3

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matic-insurance/redis-claim. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Redis::Claim project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/matic-insurance/redis-claim/blob/master/CODE_OF_CONDUCT.md).
