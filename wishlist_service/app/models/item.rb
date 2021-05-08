# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :wishlist

  validates :product_id, numericality: { only_integer: true, greater_than: 0 }
end
