Download.all.each do |download|
  download.creator = download.submission.user
  download.save!
end