require 'faker'

FactoryGirl.define do
  factory :upload do
    name { Faker::Commerce.product_name }
    version { Faker::App.version }
    approved { false }
    denied { false }
    submission { create(:submission) }
    upload { File.open(File.join(Rails.root, 'spec', 'data', 'Matchbox_Isle.zip')) }
  end
end