# frozen_string_literal: true

class ProductsConsumer < Racecar::Consumer
  CACHE_NAME = 'Products#cache'.freeze

  subscribes_to 'PRODUCTS_CHANNEL'

  def initialize
    @cache = Rails.cache
  end

  def process(message)
    type, obj = message.key, JSON.parse(message.value)
    products ||= @cache.read(CACHE_NAME) || []

    case type
    when 'CREATED'
      @cache.write(CACHE_NAME, products.push(obj))
    when 'DESTROYED'
      products.delete(obj)
      @cache.write(CACHE_NAME, products)
    else
      Rails.log.error("Type not found #{type}")
    end

    puts 'CACHE UPDATED'
    puts @cache.read(CACHE_NAME)
  rescue JSON::ParserError => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
