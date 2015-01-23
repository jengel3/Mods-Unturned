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

  def welcome(user)
    @user = user
    return if !@user.accepts_emails
    mail(:to => @user.email,
        :subject => "Successfully Registered on Mods-Unturned",
        :reply_to => @@reply)
  end

  def denied(upload, reason)
    @user = upload.submission.user
    return if !@user.accepts_emails
    @email = @user.email
    @upload = upload
    @reason = reason
    mail(:to => @email,
         :subject => "#{@upload.submission.name} Download Denied",
         :reply_to => @@reply)
  end

  def approved(upload)
    user = upload.submission.user
    return if !user.accepts_emails
    @username = user.username
    @email = user.email
    @upload = upload
    mail(:to => @email,
         :subject => "#{@upload.submission.name} Download Approved",
         :reply_to => @@reply)
  end

  def milestone(submission, count)
    @user = submission.user
    return if !@user.accepts_emails
    @submission = submission.name
    @count = count
    mail(:to => @user.email,
        :subject => "A Submission of Yours on mods-unturned.com has reached #{count} downloads!",
        :reply_to => @@reply)
  end

  def comment(comment)
    @comment = comment
    return if !@comment.user.accepts_emails
    @submission = comment.submission
    mail(:to => @comment.submission.user.email,
        :subject => "Your Submission Has Received a Comment",
        :reply_to => @@reply)
  end
end
