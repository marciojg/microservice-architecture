# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.belongs_to :category, index: true, foreign_key: true
      t.string :name, null: false, limit: 50
      t.bigint :total_access, default: 0
      t.decimal :value, precision: 32, scale: 8

      t.timestamps
    end

    add_index(:products, :total_access)
  end
end
