# frozen_string_literal: true

class Wishlist < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :client_id, numericality: { only_integer: true, greater_than: 0 }
end
