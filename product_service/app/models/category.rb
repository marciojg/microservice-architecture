# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true,
                   length: { maximum: 50 }
end
