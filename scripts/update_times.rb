Submission.where(:last_update => nil).each do |s|
  latest = s.latest_download
  next if !latest
  s.last_update = latest.updated_at
  s.save!
end