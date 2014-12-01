Submission.all.each do |s|
  s.approved_at = s.created_at
  s.save!
end