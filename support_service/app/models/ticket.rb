# frozen_string_literal: true

class Ticket < ApplicationRecord
  enum status: %i[open closed]

  with_options presence: true do
    validates :description, length: { maximum: 4000 }
    validates :client_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :order_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end

  def close
    self.status = :closed
    self.save
  end
end
