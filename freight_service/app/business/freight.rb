# frozen_string_literal: true

class Freight
  include ActiveModel::Model

  BASE_PRICE = 10.freeze

  attr_accessor :total_price, :total_items, :zip_code

  with_options presence: true, numericality: { greater_than_or_equal_to: 0 } do
    validates :total_price, :total_items
    validates :zip_code, length: { is: 8 }
  end

  validate :zip_code_valid

  def calculate
    BASE_PRICE + (total_items + (total_price.to_f / 10) * 0.5)
  end

  private

  def zip_code_valid
    return if ViaCepService.call(zip_code)

    errors.add :zip_code, :invalid, message: "invalid zipcode %{value}, try again"
  end
end
