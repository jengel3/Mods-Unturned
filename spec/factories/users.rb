require 'faker'

FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name[0..15] }

    email { Faker::Internet.email }
    admin { false }
    pass = Faker::Internet.password
    password { pass }
    encrypted_password { pass }
  end
end