# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0, null: false
      t.bigint :cart_client_id, null: false
      t.decimal :freight_value, precision: 32, scale: 8
      t.decimal :total_price, precision: 32, scale: 8
      t.integer :total_items

      t.timestamps
    end
  end
end
