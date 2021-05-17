# frozen_string_literal: true

class Item < ApplicationRecord
  include Products

  before_validation do
    return if product_id.blank?

    self.value = product_value(product_id)
  end

  after_create { produce_message('CREATED') }
  after_destroy { produce_message('DESTROYED') }

  belongs_to :wishlist

  validates :product_id, numericality: { only_integer: true, greater_than: 0 },
                         uniqueness: { scope: :wishlist },
                         inclusion: { in: :valid_product_ids, message: "%{value} is not a valid" }

  validates :value, numericality: { greater_than_or_equal_to: 0 }

  def produce_message(key)
    obj = { id: self.id, product_id: self.product_id, value: self.value }.to_json

    DeliveryBoy.deliver(obj, key: key, topic: 'WISHLIST_ITEMS_CHANNEL')
  end
end
