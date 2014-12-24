require 'faker'

FactoryGirl.define do
  factory :submission do
    name { Faker::Commerce.product_name }
    body { Faker::Lorem.paragraph }
    type { ['Level', 'Asset'].sample }
    user { create(:user) }
  end
end