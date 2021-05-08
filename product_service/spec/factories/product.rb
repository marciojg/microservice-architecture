# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    category

    name { 'Camisa XYZ' }
    value { 10.20 }
  end
end
