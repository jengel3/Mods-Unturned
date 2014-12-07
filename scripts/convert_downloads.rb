Submission.all.each do |submission|
  submission.old_downloads.to_i.times do
    Download.create(:upload => submission, :ip => "0.0.0.0", :user => nil).save!
  end
end