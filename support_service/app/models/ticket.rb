# frozen_string_literal: true

class Ticket < ApplicationRecord
  include Orders

  enum status: %i[open closed]

  validates :description, presence: true, length: { maximum: 4000 }
  validates :client_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                        inclusion: { in: :valid_order_client_ids, message: "%{value} is not a valid" }

  validates :order_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 },
                       inclusion: { in: :valid_order_ids, message: "%{value} is not a valid" }

  def close
    self.status = :closed
    self.save
  end
end
