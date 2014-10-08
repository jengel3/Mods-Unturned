module ApplicationHelper
  def can_manage(submission)
    current_user and (submission.user == current_user or current_user.admin?)
  end
end
