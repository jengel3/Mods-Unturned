Submission.all.each do |submission|
  submission.downloads.times do
    Download.create(:upload => submission, :ip => "0.0.0.0", :user => nil).save!
  end
end