module ApplicationHelper
  def can_manage(submission)
    current_user and (submission.user == current_user or current_user.admin?)
  end

  def verify_manager
    redirect_to root_path, :alert => "No permission." unless can_manage(@submission)
  end

  def user_is_admin
    current_user and current_user.admin?
  end

  def require_admin
    redirect_to root_path, :alert => "No permission." unless user_is_admin
  end

  def get_request_ip
    request.headers['X-Forwarded-For'] || request.ip
  end

  def image_full_url(source)
    "#{root_url}#{image_path(source)}"
  end

  def get_active(tab, to_return='active')
    return (params[:controller] == tab || (params[:controller].start_with?('devise') && tab == 'users') ? to_return : '')
  end
end
