# frozen_string_literal: true

class Item < ApplicationRecord
  include Products

  belongs_to :wishlist

  with_options numericality: { only_integer: true, greater_than: 0 } do
    validates :product_id, uniqueness: { scope: :wishlist }
    validates :amount
  end

  validates :product_id, inclusion: { in: :valid_product_ids,
  message: "%{value} is not a valid" }
end
