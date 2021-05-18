# frozen_string_literal: true

class CartItemsConsumer < Racecar::Consumer
  subscribes_to 'CART_ITEMS_REMOVE_CHANNEL', start_from_beginning: true

  def process(message)
    id = message.value

    cart = Cart.find_by(client_id: id)
    cart.items.destroy_all
  rescue ActiveRecord::RecordNotFound, NoMethodError => e
    puts "Failed to process message #{message.value} of key #{message.key} in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
