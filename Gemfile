source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.2.0'
gem 'uglifier', '2.7.0'

# API
gem 'jbuilder'

# Authentication
gem 'devise'
gem 'omniauth-steam'

# Pagination / UI
gem 'kaminari'
gem 'jquery-rails'

# File uploads
gem 'carrierwave-mongoid'

# Database
gem 'mongoid'
gem 'bson_ext'
gem 'mongoid_paranoia'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'mongoid-slug'

# Searching
gem 'mongoid-elasticsearch'

# Caching
gem 'redis'

# Job management
gem 'sidekiq'

# News utilities
gem 'httparty'
gem 'bb-ruby', github: 'Jake0oo0/bb-ruby'
gem 'best_in_place', '~> 3.0.1'
gem 'nokogiri'

# ZIP validation
# gem 'rubyzip'
# gem 'zip-zip'

# Email compiler
gem 'premailer-rails'

# Testing
gem 'faker'

# Windows Rails fix
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]


# Testing
group :production do
  gem 'passenger'
end

group :development do
  gem 'better_errors'
  gem 'thin'
end

group :development, :test do 
  gem 'rspec-rails' 
  gem 'factory_girl_rails'
end 

group :test do 
  gem 'capybara'
end
