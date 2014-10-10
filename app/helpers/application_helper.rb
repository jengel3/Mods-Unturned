module ApplicationHelper
  def can_manage(submission)
    current_user and (submission.user == current_user or current_user.admin?)
  end

  def user_is_admin
    current_user and current_user.admin?
  end

  def require_admin
    redirect_to root_path unless user_is_admin
  end
end
