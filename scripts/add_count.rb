Submission.where(:total_downloads.exists => false).each do |submission|
  submission.total_downloads = submission.old_downloads
  submission.save!
end