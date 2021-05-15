# frozen_string_literal: true

class ProductsConsumer < Racecar::Consumer
  CACHE_NAME = 'Products#cache'.freeze

  subscribes_to 'products'

  def initialize
    @cache = Rails.cache
  end

  def process(message)
    type, id = message.key, message.value
    products ||= @cache.read(CACHE_NAME) || []

    case type
    when 'CREATED'
      @cache.write(CACHE_NAME, products.push(id))
    when 'DESTROYED'
      products.delete(id)
      @cache.write(CACHE_NAME, products)
    else
      Rails.log.error("Type not found #{type}")
    end

    puts 'CACHE UPDATED'
    puts @cache.read(CACHE_NAME)
  end
end
