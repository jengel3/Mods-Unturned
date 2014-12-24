require 'faker'

FactoryGirl.define do
  factory :image do
    location { "Main" }
    submission { create(:submission) }
  end
end