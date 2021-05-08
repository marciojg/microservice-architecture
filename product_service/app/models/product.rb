# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, 
                   length: { maximum: 50 }


  def new_access!
    self.total_access += 1
    self.save!
  end
end
