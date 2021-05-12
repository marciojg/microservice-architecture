# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :wishlist

  with_options numericality: { only_integer: true, greater_than: 0 } do
    validates :product_id, uniqueness: { scope: :wishlist }
    validates :amount
  end
end
