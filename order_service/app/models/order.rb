# frozen_string_literal: true

class Order < ApplicationRecord
  include Carts

  after_create :calculate_freight

  enum status: %i[open closed]

  validates :cart_client_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                             inclusion: { in: :valid_cart_client_ids, message: "%{value} is not a valid" }

  def close
    self.status = :closed
    self.save

    remove_items
  end

  def calculate_freight
    delivery_message('CALCULATE_FREIGHT_CHANNEL')
  end

  def remove_items
    delivery_message('CART_ITEMS_REMOVE_CHANNEL')
  end

  def delivery_message(topic)
    DeliveryBoy.deliver(self.cart_client_id, topic: topic)
  end
end
