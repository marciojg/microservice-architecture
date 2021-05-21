# frozen_string_literal: true

class OrdersConsumer < Racecar::Consumer
  CACHE_NAME = 'Orders#cache'.freeze

  subscribes_to 'ORDERS_CHANNEL', start_from_beginning: true

  def initialize
    @cache = Rails.cache
  end

  def process(message)
    type, obj = message.key, JSON.parse(message.value)
    list ||= @cache.read(CACHE_NAME) || []

    case type
    when 'CREATED'
      @cache.write(CACHE_NAME, list.push(obj))
    when 'CLOSED'
      list.delete(obj)
      @cache.write(CACHE_NAME, list)
    else
      Rails.log.error("Type not found #{type}")
    end

    puts 'CACHE UPDATED'
    puts @cache.read(CACHE_NAME)
  rescue JSON::ParserError => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
