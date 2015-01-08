
json.timestamps do
  json.last_update @submission.last_update
  json.created_at @submission.created_at
  json.approved_at @submission.approved_at
  json.favorited_at @submission.last_favorited  
end

json.downloads do
  json.total @submission.total_downloads
end

json.uploads @submission.uploads.where(:approved => true).desc(:created_at).limit(5) do |upload|
	json.url submission_download_path(@submission)
	json.filename upload.upload.file.filename
end

json.videos @submission.videos do |video|
	json.url video.url
	json.thumbnail video.thumbnail
	json.submitter video.submitter.username
end

json.comments @submission.comments do |comment|
  json.text comment.text
  json.created comment.created_at
  json.creator comment.user.username
end