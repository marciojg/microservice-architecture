# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.belongs_to :wishlist, null: false, index: true, foreign_key: true
      t.bigint :product_id, null: false
      t.decimal :value, precision: 32, scale: 8, null: false

      t.timestamps
    end
  end
end
