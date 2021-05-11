FactoryBot.define do
  factory :ticket do
    status { 1 }
    description { "MyText" }
    client_id { 123 }
  end
end
