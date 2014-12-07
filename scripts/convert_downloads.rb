Submission.all.each do |submission|
  puts submission.old_downloads
  submission.old_downloads.to_i.times do
    Download.create(:upload => submission, :ip => "0.0.0.0", :user => nil).save!
  end
end