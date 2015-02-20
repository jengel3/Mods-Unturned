json.page do
	json.current @page
	json.max @max
end
json.array! @comments do |comment|
	json.id comment.id.to_s
	json.text comment.text
	json.submission_id comment.submission.id.to_s
	json.user comment.user.username
end