Submission.all.each do |submission|
  puts submission.old_downloads
  submission.old_downloads.to_i.times do
    submission.downloads.create(:upload => submission, :ip => "0.0.0.0", :user => nil)
  end
end
puts "Successfully converted old download counter to new models."