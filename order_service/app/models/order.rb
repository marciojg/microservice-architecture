# frozen_string_literal: true

class Order < ApplicationRecord
  enum status: %i[open closed]

  with_options presence: true do
    validates :item_ids
    validates :client_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end

  def close
    self.status = :closed
    self.save
  end
end
