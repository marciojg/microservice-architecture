# frozen_string_literal: true

class Item < ApplicationRecord
  include Products

  before_validation do
    return if product_id.blank?

    self.value = product_value(product_id)
  end

  belongs_to :wishlist

  validates :product_id, numericality: { only_integer: true, greater_than: 0 },
                         uniqueness: { scope: :wishlist },
                         inclusion: { in: :valid_product_ids, message: "%{value} is not a valid" }

  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
