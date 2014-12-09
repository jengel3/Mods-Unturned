Submission.all.each do |submission|
  puts submission.total_downloads
  if !submission.can_show?
    puts "Removing..."
    submission.approved_at = nil
    submission.save!
  end
  puts submission.approved_at
end