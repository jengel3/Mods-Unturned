xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Submissions Index"
    xml.description "A RSS feed for Mods Unturned submissions"
    xml.link submissions_url

    for submission in @submissions
      xml.item do
        xml.title submission.name
        xml.description submission.desc
        xml.pubDate submission.created_at.to_s(:rfc822)
        xml.link submission_url(submission)
        xml.guid submission_url(submission)
      end
    end
  end
end