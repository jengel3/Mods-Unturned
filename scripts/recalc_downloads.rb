Submission.each do |submission|
  submission.total_downloads = submission.downloads.count
  submission.save
end