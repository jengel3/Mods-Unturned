json.(@submission, :name, :body, :type)
json.summary @submission.desc
json.new @submission.is_new?
json.updated @submission.is_updated?

json.timestamps do
  json.last_update @submission.last_update
  json.created_at @submission.created_at
  json.approved_at @submission.approved_at
  json.favorited_at @submission.last_favorited  
end

json.downloads do
  json.total @submission.total_downloads
end

json.uploads @uploads do |upload|
  json.path submission_upload_download_path(@submission, upload)
  json.filename upload.upload.file.filename
  json.name upload.name
  json.version upload.version
  json.uploaded upload.created_at
end

json.videos @submission.videos do |video|
  json.url video.url
  json.thumbnail video.thumbnail
  json.submitter video.submitter.username
end

json.comments do
  json.count @submission.comments.count
  json.shown @comments.count
  json.list do
    json.array! @comments do |comment|

      json.text comment.text
      json.created comment.created_at
      json.creator comment.user.username
    end
  end
end