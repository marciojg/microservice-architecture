# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :status, default: 0, null: false
      t.bigint :client_id, null: false
      t.bigint :item_ids, array: true, default: []

      t.timestamps
    end
  end
end
