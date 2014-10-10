class UserMailer < ActionMailer::Base
  default from: "noreply@jake0oo0.me"

  def approve(submission, download, user)
    @username = user.username
    @submission = submission
    @download = download
    mail(:to => email,
         :subject => "Your plugin download has been approved.",
         :reply_to => "info@jake0oo0.me")
  end

  def approve(submission, download, user)
    @username = user.username
    @submission = submission
    @download = download
    mail(:to => email,
         :subject => "Your plugin download has been denied.",
         :reply_to => "info@jake0oo0.me")
  end
end
