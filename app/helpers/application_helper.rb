module ApplicationHelper
  def can_manage(submission)
    current_user and (submission.user == current_user or current_user.admin?)
  end

  def verify_manager
    redirect_to root_path, :alert => t('users.no_permission') unless can_manage(@submission)
  end

  def user_is_admin
    current_user and current_user.admin?
  end

  def require_admin
    redirect_to root_path, :alert => t('users.no_permission') unless user_is_admin
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

  def category(name, image)
    link_to category_path(name.downcase) do
      content_tag :div, class: 'category' do
        image_tag(image, alt: name) +
        content_tag(:h1, name)
      end
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

  def sortable(field, name=nil)
    name ||= field.humanize
    current_sort = params[:sort]
    opposite = ''
    if current_sort == field
      name += ' ^'
      opposite = '-' + field
    elsif current_sort == '-' + field
      name += ' \/'
      opposite = field
    else
      opposite = field
    end
    return link_to name, params.merge(:sort => opposite)
  end
end
