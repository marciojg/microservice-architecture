# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.integer :status, default: 0, null: false
      t.text :description, null: false, limit: 4000
      t.bigint :client_id, null: false

      t.timestamps
    end
  end
end
