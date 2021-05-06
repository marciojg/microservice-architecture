# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true, 
                   length: { maximum: 50 }
end
