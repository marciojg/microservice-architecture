# frozen_string_literal: true

module Orders
  extend ActiveSupport::Concern

  included do
    def valid_order_client_ids
      @order_client_id_list ||= order_list.map { |order| order['cart_client_id'].to_i }
    end

    def valid_order_ids
      @order_id_list ||= order_list.map { |order| order['order_id'].to_i }
    end

    private

    def order_list
      Rails.cache.read(OrdersConsumer::CACHE_NAME) || []
    end
  end
end
