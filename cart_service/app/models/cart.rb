class Cart < ApplicationRecord
  self.primary_key = :client_id

  after_create { produce_message('CREATED') }
  after_destroy { produce_message('DESTROYED') }

  delegate :total_amount, to: :items, prefix: :item
  delegate :total_value, to: :items, prefix: :item

  has_many :items, foreign_key: :cart_client_id, dependent: :restrict_with_error

  validates :client_id, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def produce_message(key)
    obj = { id: self.id, client_id: self.client_id }.to_json

    DeliveryBoy.deliver(obj, key: key, topic: 'CARTS_CHANNEL')
  end
end
