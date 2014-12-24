require 'faker'

FactoryGirl.define do
  factory :video do
    url { "https://www.youtube.com/watch?v=#{['ePNCIz7x6IM', 'p11cpLpHKNk'].sample}" }
  end
end