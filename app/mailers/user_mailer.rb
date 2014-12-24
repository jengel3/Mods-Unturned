class UserMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default from: "no-reply@mods-unturned.com"
  @@reply = "no-reply@mods-unturned.com"

  def contact(username, email, inquiry)
    @username = username
    @email = email
    @inquiry = inquiry
    mail(:to => "jake0oo0dev@gmail.com; modsunturned@gmail.com",
         :subject => "#{username} has sent an inquiry to Mods Unturned.",
         :reply_to => @email)
  end

  def denied(user, download)
    @username = user.username
    @email = user.email
    @download = download
    mail(:to => @email,
         :subject => "A download for your submission #{download.submission} has been denied.",
         :reply_to => @@reply)
  end

  def approved(user, download)
    @username = user.username
    @email = user.email
    @download = download
    mail(:to => @email,
         :subject => "A download for your submission #{download.submission} has been approved.",
         :reply_to => @@reply)
  end

  def milestone(submission, count)
    @user = submission.user
    @submission = submission.name
    @count = count
    mail(:to => @user.email,
        :subject => "A Submission of Yours on mods-unturned.com has reached #{count} downloads!",
        :reply_to => @@reply)
  end
end
