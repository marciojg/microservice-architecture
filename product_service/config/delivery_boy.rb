# https://github.com/zendesk/delivery_boy#configuration
# Design Pattern Circuit Breaker implementado por default pelo Framework DeliveryBoy
DeliveryBoy.configure do |config|
  config.client_id = Etcdv3.new(endpoints: 'http://etcd:2379').get("#{Rails.env}/product_service/client_id").kvs.first.value
  config.brokers = [
    Etcdv3.new(endpoints: 'http://etcd:2379').get("#{Rails.env}/product_service/brokers").kvs.first.value
  ]

  config.delivery_interval = 0.005         # Trigger a delivery every 0.005 seconds.
  config.delivery_threshold = 5            # Trigger a delivery once 5 messages have been buffered.
  config.max_queue_size = 10               # The maximum number of messages allowed in the queue before new messages are rejected.
  config.max_retries = 5                   # The number of retries when attempting to deliver messages.
  config.retry_backoff = 5                 # The number of seconds to wait between retries. In order to handle longer periods of Kafka being unavailable, increase this number.
end
