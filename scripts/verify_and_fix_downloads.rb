Submission.each do |submission|
  created_count = submission.downloads.count
  if created_count != submission.total_downloads
    puts "Adding #{created_count} downloads for #{submission.name}"
    created_count -= submission.total_downloads
    created_count.times do
      submission.downloads.create(:upload => submission, :ip => "0.0.0.0", :user => nil, creator: submission.user)
    end
  end
end