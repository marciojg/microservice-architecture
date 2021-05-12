# frozen_string_literal: true

class Freight
  include ActiveModel::Model

  BASE_PRICE = 10

  attr_accessor :total_price, :total_items, :zip_code

  with_options presence: true, numericality: { greater_than_or_equal_to: 0 } do
    validates :total_price, :total_items
    validates :zip_code, length: { is: 8 }
  end

  def calculate
    price = BASE_PRICE + (total_items + (total_price / 10) * 0.5)

    price
  end
end
