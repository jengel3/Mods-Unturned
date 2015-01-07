json.stats do
	json.downloads Submission.valid.sum(:total_downloads)
	json.submisions Submission.valid.count
	json.users User.count
	json.comments Comment.count
end