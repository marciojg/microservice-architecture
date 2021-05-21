# frozen_string_literal: true

class Order < ApplicationRecord
  include Carts

  after_create do
    delivery_message('ORDERS_CHANNEL', 'CREATED')
    delivery_message('TOTAL_ITEMS_CHANNEL')
  end

  enum status: %i[open closed]

  validates :cart_client_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                             uniqueness: { conditions: -> { where(status: :open) } },
                             inclusion: { in: :valid_cart_client_ids, message: "%{value} is not a valid" }

  def close
    self.status = :closed
    self.save

    delivery_message('CART_ITEMS_REMOVE_CHANNEL')
    delivery_message('ORDERS_CHANNEL', 'CLOSED')
  end

  private

  def delivery_message(topic, key = nil)
    obj = { order_id: self.id, cart_client_id: self.cart_client_id }

    DeliveryBoy.deliver(obj, key: key, topic: topic)
  end
end
