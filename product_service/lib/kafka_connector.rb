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

  def self.produce(data, key:, topic:)
    @producer ||= client.async_producer(delivery_threshold: 5, delivery_interval: 0.005)
    @producer.produce(data, key: key, topic: topic)
  rescue Kafka::Error => e
    Rails.logger.error("Failed to produce data #{data}: #{e.message}")
  ensure
    @producer.deliver_messages
    @producer.shutdown
  end
end
