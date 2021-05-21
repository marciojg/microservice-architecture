# frozen_string_literal: true

class Item < ApplicationRecord
  include Products
  include WishlistItems

  after_create :produce_message_to_remove_wishlist_item, unless: -> { self.wishlist_item_id.nil? }

  before_validation do
    self.value = product_value(product_id) if product_id.present? && wishlist_item_id.blank?

    if wishlist_item_id.present?
      self.value = wishlist_item_value(wishlist_item_id)
      self.product_id = wishlist_item_product_id(wishlist_item_id)
    end
  end

  belongs_to :cart, foreign_key: :cart_client_id

  validates :value, numericality: { greater_than_or_equal_to: 0 }

  with_options numericality: { only_integer: true, greater_than_or_equal_to: 0 } do
    validates :amount

    validates :wishlist_item_id, uniqueness: { scope: :cart },
                                 inclusion: { in: :valid_wishlist_item_ids, message: "%{value} is not a valid" },
                                 unless: -> { self.wishlist_item_id.nil? }

    validates :product_id, uniqueness: { scope: :cart },
                           inclusion: { in: :valid_product_ids, message: "%{value} is not a valid" }
  end

  def self.total_amount
    sum(:amount)
  end

  def self.total_value
    sum(:value)
  end

  private

  def produce_message_to_remove_wishlist_item
    obj = { wishlist_item_id: self.wishlist_item_id }.to_json

    DeliveryBoy.deliver(obj, key: self.cart_client_id, topic: 'DELETE_WISHLIST_ITEM_CHANNEL')
  end
end
