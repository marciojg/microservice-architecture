class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts, id: false do |t|
      t.bigint :client_id, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
