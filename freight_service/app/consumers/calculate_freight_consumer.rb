# frozen_string_literal: true

class CalculateFreightConsumer < Racecar::Consumer
  subscribes_to 'CALCULATE_FREIGHT_CHANNEL', start_from_beginning: true

  def process(message)
    client_id, calculate_params = message.key, JSON.parse(message.value)

    freight = Freight.new(calculate_params)

    if freight.valid?
      result = { client_id: client_id, freight_value: freight.calculate }.to_json

      DeliveryBoy.deliver(result, key: 'OK', topic: 'CALCULATE_FREIGHT_CHANNEL_REPLY')
    else
      result = { client_id: client_id }.merge freight.errors.to_h

      DeliveryBoy.deliver(result.to_json, key: 'ERROR', topic: 'CALCULATE_FREIGHT_CHANNEL_REPLY')
    end
  rescue JSON::ParserError, ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid => e
    puts "Failed to process message in #{message.topic}/#{message.partition} at offset #{message.offset}: #{e}"
  end
end
