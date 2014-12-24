require 'faker'

FactoryGirl.define do
  factory :download do
    ip { Faker::Internet.ip_v4_address }
    submission { create(:submission) }
    upload { create(:upload, submission: submission) }
    creator { submission.user }
    user { create(:user) }
  end
end