# frozen_string_literal: true

class TotalItemsConsumer < Racecar::Consumer
  subscribes_to 'TOTAL_ITEMS_CHANNEL', start_from_beginning: true

  def process(message)
    order = JSON.parse(message.value)

    cart = Cart.find(order['cart_client_id'])

    obj = { total_items: cart.item_total_amount, total_price: cart.item_total_value }.to_json
    DeliveryBoy.deliver(obj, topic: 'TOTAL_ITEMS_REPLY_CHANNEL', key: order['cart_client_id'])
  rescue JSON::ParserError, ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
