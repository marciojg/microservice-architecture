class Cart < ApplicationRecord
  self.primary_key = :client_id

  has_many :items, foreign_key: :cart_client_id, dependent: :restrict_with_error

  validates :client_id, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
