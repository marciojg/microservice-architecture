# frozen_string_literal: true

module Products
  extend ActiveSupport::Concern

  included do
    def valid_product_ids
      @product_list ||= product_list.map { |prod| prod['id'].to_i }
    end

    def product_value(id)
      value = product_list.find { |prod| prod['id'].to_i == id }&.fetch('value')

      @produc_value ||= value.to_f
    end

    private

    def product_list
      Rails.cache.read('Products#cache') || []
    end
  end
end
