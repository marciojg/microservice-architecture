class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.bigint :cart_client_id, null: false, index: true
      t.bigint :product_id, null: false
      t.bigint :wishlist_item_id
      t.decimal :value, precision: 32, scale: 8, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
