## TO-DO
  - criar desenho da arquitetura


# Subir o projeto

Subir kafka

```bash
  docker-compose -f docker-compose-kafka.yml up
```

Subir serviços

```bash
  docker-compose -f docker-compose-services.yml up
```

subir tudo
```bash
chmod +x start.sh
start.sh
```


-------------------------------
# frozen_string_literal: true

require 'kafka'

# https://github.com/confluentinc/examples/blob/6.1.1-post/clients/cloud/ruby/producer.rb
class KafkaConnector
  BROKERS = ['kafka:29092'].freeze
  SEED_BROKERS = 'kafka:29092'.freeze
  CLIENT_ID = 'PRODUCT_SERVICE'.freeze

  def self.client
    @client ||= Kafka.new(BROKERS, seed_brokers: SEED_BROKERS, client_id: CLIENT_ID)
  end

  # https://github.com/zendesk/ruby-kafka#buffering-and-error-handling
  # Design Pattern Circuit Breaker implementado por default pela lib ruby-kafka usando buffer de mensagem em memória
  def self.produce(data, key:, topic:)
    @producer ||= client.async_producer(
      delivery_threshold: 5,            # Trigger a delivery once 5 messages have been buffered.
      delivery_interval: 0.005,         # Trigger a delivery every 0.005 seconds.
      max_buffer_size: 5_000,           # Allow at most 5K messages to be buffered.
      max_buffer_bytesize: 100_000_000, # Allow at most 100MB to be buffered.
      required_acks: :all,              # This is the default: all replicas must acknowledge.
      max_retries: 5,                   # The number of retries when attempting to deliver messages.
      retry_backoff: 5,                 # The number of seconds to wait between retries. In order to handle longer periods of Kafka being unavailable, increase this number.
    )
    @producer.produce(data, key: key, topic: topic)
  rescue Kafka::Error => e
    Rails.logger.error("Failed to produce data #{data}: #{e.message}")
  ensure
    @producer.deliver_messages
    @producer.shutdown
  end

  def self.consume(topic, default_offset: :earliest)
    @consumer ||= client.consumer(group_id: "#{CLIENT_ID}-CONSUMER")

    @consumer.subscribe(topic, default_offset: default_offset)

    @consumer.each_message do |message|
      record_key = message.key
      record_value = message.value

      puts "Consumed record with key #{record_key} and value #{record_value}"
    end

    @consumer
    # at_exit do
    #   @consumer.stop # Leave group and commit final offsets
    # end
  rescue Kafka::Error => e
    puts "Consuming messages from #{topic} failed: #{e.message}"
  end
end

-------------------------------
  # config.brokers = ServiceDiscovery.find("kafka-brokers")
-------------------------------
  CACHE_NAME = 'Products#cache'.freeze

  subscribes_to 'products'
  @cache = Rails.cache.read('Products#cache')
# rafatorar isso 'Products#cache'
@cache.read(CACHE_NAME)
-------------------------------


docker-compose logs -f -t
docker-compose -f docker-compose-freight.yml logs -f -t

-----------------
estou usando api compostition

SAGA Event Sourcing
