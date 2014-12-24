require 'faker'

FactoryGirl.define do
  factory :comment do
    user { create(:user) }
    text { Faker::Lorem.paragraph }
    submission { create(:submission) }
  end
end