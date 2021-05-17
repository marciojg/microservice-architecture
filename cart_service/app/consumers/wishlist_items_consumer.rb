# frozen_string_literal: true

class WishlistItemsConsumer < Racecar::Consumer
  CACHE_NAME = 'WishlistItems#cache'.freeze

  subscribes_to 'WISHLIST_ITEMS_CHANNEL'

  def initialize
    @cache = Rails.cache
  end

  def process(message)
    type, obj = message.key, JSON.parse(message.value)
    wishlist_items ||= @cache.read(CACHE_NAME) || []

    case type
    when 'CREATED'
      @cache.write(CACHE_NAME, wishlist_items.push(obj))
    when 'DESTROYED'
      wishlist_items.delete(obj)
      @cache.write(CACHE_NAME, wishlist_items)
    else
      Rails.log.error("Type not found #{type}")
    end

    puts 'CACHE UPDATED'
    puts @cache.read(CACHE_NAME)
  rescue JSON::ParserError => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
