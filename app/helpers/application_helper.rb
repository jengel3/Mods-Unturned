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

  def user_menu
    if !current_user
      return link_to "<div class=\"menutext\">#{t('users.log_in')}</div>".html_safe, '#login-popup', class: (!current_user ? 'login-button' : '')
    elsif current_user && params[:controller] == 'submissions' && params[:action] == 'index' && params[:user]
      return link_to "<div class=\"menutext\">#{t('users.log_out')}</div>".html_safe, destroy_user_session_path, :method => :delete
    else
      return link_to "<div class=\"menutext\">#{current_user.username}</div>".html_safe, user_uploads_path(current_user.username)
    end
  end

  def user_img_menu
    if !current_user
      return link_to '', new_user_registration_path, class: "menuimgwrap #{params[:user] && params[:controller] == 'submissions' ? 'active-image' : ''}"
    elsif current_user && params[:controller] == 'submissions' && params[:action] == 'index' && params[:user]
      return link_to '', destroy_user_session_path, :method => :delete, class: "menuimgwrap #{params[:user] && params[:controller] == 'submissions' ? 'active-image' : ''}"
    else
      return link_to '', user_uploads_path(current_user.username), class: "menuimgwrap #{params[:user] && params[:controller] == 'submissions' ? 'active-image' : ''}"
    end
  end

  def resource_name
    :user
  end
  
  def resource
    @resource ||= User.new
  end
  
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
