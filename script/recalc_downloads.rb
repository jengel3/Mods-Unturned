Submission.each do |submission|
  original = submission.total_downloads
  new_count = submission.downloads.count
  submission.total_downloads = new_count
  submission.save
  change = new_count - original
  puts "Download count change: #{change}"
end