# frozen_string_literal: true

module Carts
  extend ActiveSupport::Concern

  included do
    def valid_cart_client_ids
      @cart_list ||= cart_list.map { |cart| cart['client_id'].to_i }
    end

    private

    def cart_list
      Rails.cache.read(CartsConsumer::CACHE_NAME) || []
    end
  end
end
