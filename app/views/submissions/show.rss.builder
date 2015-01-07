xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Downloads for #{@submission.name}"
    xml.description "A RSS feed for Mods Unturned submission #{@submission.name}"
    xml.link submissions_url

    for upload in @submission.uploads.where(:approved => true)
      xml.item do
        xml.title upload.name
        xml.description "Version: #{upload.version} - Filename: #{upload.upload.file.filename} - Size: #{upload.upload.download_size.join('')}"
        xml.pubDate upload.created_at.to_s(:rfc822)
        xml.link submission_download_url(@submission)
        xml.guid submission_download_url(@submission, :uuid => upload.id)
      end
    end
  end
end