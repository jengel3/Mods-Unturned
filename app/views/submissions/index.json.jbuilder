json.page do
	json.prev "1"
	json.current "2"
	json.next "3"
end

json.array! @submissions do |submission|
  json.name submission.name
  json.body submission.body
  json.summary submission.desc
  json.downloads submission.total_downloads
  json.new submission.is_new?
  json.updated submission.is_updated?
  json.urls do
  	json.submission submission_path(submission)
  	if submission.main_image
  		json.large_image submission.main_image.image_url
  	else
  		json.large_image null
  	end
  end
  json.timestamps do
  	json.last_update submission.last_update
  	json.created_at submission.created_at
  	json.approved_at submission.approved_at
  	json.favorited_at submission.last_favorited
  end
  json.author do
    json.username submission.user.username
    json.submissions submission.user.submissions.count
    json.url user_uploads_path(submission.user.username)
  end
end