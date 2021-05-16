# frozen_string_literal: true

class Product < ApplicationRecord
  after_create { produce_message('CREATED') }
  after_destroy { produce_message('DESTROYED') }

  belongs_to :category

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :value, numericality: { greater_than_or_equal_to: 0 }

  def new_access!
    self.total_access += 1
    self.save!
  end

  private

  def produce_message(key)
    DeliveryBoy.deliver({ id: self.id, value: self.value }.to_json, key: key, topic: 'PRODUCTS')
  end
end
