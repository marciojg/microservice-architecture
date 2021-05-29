# frozen_string_literal: true

class TotalItemsReplyConsumer < Racecar::Consumer
  subscribes_to 'TOTAL_ITEMS_REPLY_CHANNEL', start_from_beginning: true

  def process(message)
    cart_client_id, obj = message.key, JSON.parse(message.value)

    order = Order.find_by!(cart_client_id: cart_client_id)
    order.update!(obj)
  rescue JSON::ParserError, ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
