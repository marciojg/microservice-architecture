FactoryBot.define do
  factory :order do
    status { 1 }
    cart_client_id { 123 }
  end
end
