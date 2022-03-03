FactoryBot.define do
  factory :material_price do
    price { rand(1..10) }
    sequence(:code) { |n| "CODE-#{n}" }
    sequence(:name) { |n| "NAME-#{n}" }
  end
end
