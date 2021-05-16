# frozen_string_literal: true

module WishlistItems
  extend ActiveSupport::Concern

  included do
    def valid_wishlist_item_ids
      @wishlist_items ||= wishlist_items.map { |item| item['id'].to_i }
    end

    def wishlist_item_value(id)
      value = wishlist_items.find { |item| item['id'].to_i == id }&.fetch('value')

      @wishlist_item_value ||= value.to_f
    end

    def wishlist_item_product_id(id)
      product_id = wishlist_items.find { |item| item['id'].to_i == id }&.fetch('product_id')

      @wishlist_item_product_id ||= product_id.to_i
    end

    private

    def wishlist_items
      Rails.cache.read(WishlistItemsConsumer::CACHE_NAME) || []
    end
  end
end
