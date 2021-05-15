# frozen_string_literal: true

module Products
  extend ActiveSupport::Concern

  included do
    attribute :product_ids, :integer, array: true

    def product_ids
      product_list.map(&:to_i)
    end

    private

    def product_list
      Rails.cache.read('Products#cache') || []
    end
  end
end
