require 'faker'

FactoryGirl.define do
  factory :image do
    location { "Main" }
    submission { create(:submission) }
    image { File.open(File.join(Rails.root, 'spec', 'data', 'Bridge.jpg')) }
  end
end