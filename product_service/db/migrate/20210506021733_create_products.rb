# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.belongs_to :category, index: { unique: true }, foreign_key: true
      t.string :name, null: false, limit: 50

      t.timestamps
    end
  end
end
