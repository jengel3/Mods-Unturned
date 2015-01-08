require 'faker'

namespace :db do
  desc "Populate a database with real life data"
  task :populate => :environment do
    count = 40
    count.times do 
      pass = Faker::Internet.password
      user = User.create!(:username => Faker::Internet.user_name[0..13] + rand(100).to_s, :email => Faker::Internet.email, encrypted_password: pass, password: pass)
      submission = Submission.create(:user => user, :name => Faker::Commerce.product_name, :body => Faker::Lorem.paragraph, :type => ['Asset', 'Level'].sample, :approved_at => Time.now)
      upload = Upload.create(:submission => submission, :upload => File.new(File.join(Rails.root, 'spec', 'data', 'Matchbox_Isle.zip')), :version => Faker::App.version, :name => Faker::App.version, :approved => true)
      image = Image.create(:submission => submission, :image => File.new(File.join(Rails.root, 'spec', 'data', 'Bridge.jpg')), :location => "Main")
      puts "Created user with username #{user.username} who owns the submission '#{submission.name}' that has an upload, and an image."
    end
  end

  desc "Populate current submissions with a download"
  task :unapprove => :environment do
    Submission.all.each do |submission|
      rand = rand(10)
      if rand <= 3
        upload = submission.uploads.first
        upload.approved = false
        upload.save
      end
    end
  end
end