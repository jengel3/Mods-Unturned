json.id @comment.id.to_s
json.text @comment.text
json.submission_id @comment.submission.id.to_s
json.user @comment.user.username