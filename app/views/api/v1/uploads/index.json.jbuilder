json.array! @uploads do |upload|
	json.id upload.id.to_s
  	json.path submission_upload_download_path(@submission, upload)
  	json.filename upload.upload.file.filename
  	json.name upload.name
  	json.version upload.version
  	json.uploaded upload.created_at
end