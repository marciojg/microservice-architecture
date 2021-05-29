# frozen_string_literal: true

class CalculateFreightReplyConsumer < Racecar::Consumer
  subscribes_to 'CALCULATE_FREIGHT_REPLY_CHANNEL', start_from_beginning: true

  def process(message)
    type, response = message.key, JSON.parse(message.value)
    client_id = response.delete('client_id')

    case type
    when 'OK'
      order = Order.find_by!(cart_client_id: client_id)
      order.update!(response)

      puts "Freight calculated to user: #{client_id}"
    when 'ERROR'
      puts "Error to calculate, client_id: #{client_id}, errors: #{response}"
    else
      puts "Type not found #{type}"
    end
  rescue JSON::ParserError, ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
