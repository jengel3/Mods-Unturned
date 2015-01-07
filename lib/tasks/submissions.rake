require 'faker'

namespace :submissions do
  desc "Clean out dead or inactive submissions"
  task :clean => :environment do
    submissions = Submission.where(:approved_at.exists => false)
    submissions.each do |submission|
      if !(submission.main_image && submission.latest_download)
        puts "Possible deletion: #{submission.id}"
      end
    end
  end
end