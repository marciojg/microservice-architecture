# frozen_string_literal: true

module Products
  extend ActiveSupport::Concern

  included do
    def valid_product_ids
      @product_list ||= product_list.map(&:to_i)
    end

    private

    def product_list
      Rails.cache.read('Products#cache') || []
    end
  end
end
