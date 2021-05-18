# frozen_string_literal: true

class ItemsDeleteConsumer < Racecar::Consumer
  subscribes_to 'DELETE_WISHLIST_ITEM_CHANNEL', start_from_beginning: true

  def process(message)
    client_id, obj = message.key, JSON.parse(message.value)

    puts "client_id: #{client_id} - obj: #{obj}"
    Item.destroy(obj['wishlist_item_id'])

  rescue ActiveRecord::RecordNotFound => e
    puts "RecordNotFound Item #{obj['wishlist_item_id']}"
  rescue JSON::ParserError => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
