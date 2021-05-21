# https://github.com/zendesk/racecar#configuration
# Design Pattern Circuit Breaker implementado por default pelo Framework Racecar
Racecar.configure do |config|
  config.client_id = 'FREIGHT_SERVICE'
  config.group_id_prefix = 'FREIGHT_SERVICE'
  config.brokers = ['kafka:29092']

  # How long to pause a partition for if the consumer raises an exception while processing a message.
  config.pause_timeout = 10

  # Set to true if you want to double the pause_timeout on each consecutive failure of a particular partition.
  pause_with_exponential_backoff = true
end
