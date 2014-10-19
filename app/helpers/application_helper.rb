module ApplicationHelper
  def can_manage(submission)
    current_user and (submission.user == current_user or current_user.admin?)
  end

  def verify_manager
    redirect_to root_path unless can_manage(@submission)
  end

  def user_is_admin
    current_user and current_user.admin?
  end

  def require_admin
    redirect_to root_path unless user_is_admin
  end

  def avatar(user, options = {})
    image = gravatar_url user.email, options
    image_tag image, :alt => "Avatar", class: 'avatar' if image.present?
  end

  def gravatar_url(email, options = {})
    require 'digest/md5' unless defined?(Digest::MD5)
    md5 = Digest::MD5.hexdigest(email.to_s.strip.downcase)
    options[:s] = options.delete(:size) || 60
    options[:d] = options.delete(:default)
    options.delete(:d) unless options[:d]
    "#{request.ssl? ? 'https://secure' : 'http://www'}.gravatar.com/avatar/#{md5}?#{options.to_param}"
  end
end
