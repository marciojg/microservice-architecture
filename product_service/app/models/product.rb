# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category

  validates :name, presence: true,
                   length: { maximum: 50 }

  validates :value, numericality: { greater_than_or_equal_to: 0 }

  def new_access!
    self.total_access += 1
    self.save!
  end
end
