# frozen_string_literal: true

class CreateWishlists < ActiveRecord::Migration[6.1]
  def change
    create_table :wishlists do |t|
      t.bigint :client_id, null: false

      t.timestamps
    end
  end
end
