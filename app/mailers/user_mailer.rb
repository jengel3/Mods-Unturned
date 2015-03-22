require 'digest/sha2'
class UserMailer < ActionMailer::Base
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@mods-unturned.com"
  add_template_helper(ApplicationHelper)
  default from: "no-reply@mods-unturned.com"
  @@reply = "no-reply@mods-unturned.com"

  def single(to, from, subject, message)
    @message = message.gsub(/\r\n/, "<br>")
    mail(:to => to,
     :subject => subject,
     :reply_to => "modsunturned@gmail.com")
  end

  def contact(username, email, inquiry)
    @username = username
    @email = email
    @inquiry = inquiry.gsub(/\r\n/, "<br>")
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
    @email = @user.email
    mail(:to => @user.email,
      :subject => "A Submission of Yours on mods-unturned.com has reached #{count} downloads!",
      :reply_to => @@reply)
  end

  def comment(comment)
    @comment = comment
    return if !@comment.submission.user.accepts_emails
    @submission = comment.submission
    @email = @submission.user.email
    mail(:to => @comment.submission.user.email,
      :subject => "Your Submission Has Received a Comment",
      :reply_to => @@reply)
  end
end
