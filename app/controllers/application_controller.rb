class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :require_admin, only: [:flush_cache, :email]
  before_filter :complete_steam_register

  def unsubscribe
    user_email = params[:email]
    user = User.where(email: user_email).first
    if user
      user.accepts_emails = false
      user.save
      return redirect_to root_path, :notice => t('emails.successfully_unsubscribed')
    end
    return redirect_to root_path, :alert => t('emails.not_found')
  end

  def send_mail
    form = params[:email]
    username = form[:username]
    from = form[:email]
    message = form[:message]
    subject = form[:subject]
    if from.empty? || username.empty? || message.empty? || subject.empty?
      return redirect_to admin_path, :alert => t('emails.please_fill')
    end
    return redirect_to admin_path, :alert => t('emails.not_found') unless user = User.where(:username => username).first
    to = user.email
    UserMailer.single(to, from, subject, message).deliver_later
    redirect_to admin_path, :notice => t('emails.successfully_sent')
  end
  
  def contact
    request_ip = get_request_ip
    captcha_resp = params["g-recaptcha-response"]
    if !captcha_resp || captcha_resp.blank?
      flash[:alert] = t('contact.please_complete')
      return redirect_to root_path
    end
    secret = "6LdXLQITAAAAAJua6hwGRSIiP-pMAnN0ql-QZZwp"
    google_resp = HTTParty.get("https://www.google.com/recaptcha/api/siteverify?secret=#{secret}&response=#{captcha_resp}&remoteip=#{request_ip}")
    result = JSON.parse(google_resp.body)
    if !result['success']
      flash[:alert] = t('contact.it_appears')
      return redirect_to root_path
    end
    form = params[:contact]
    email = form[:email]
    username = form[:username]
    inquiry = form[:inquiry]
    if email.empty? || username.empty? || inquiry.empty?
      return redirect_to root_path, :alert => t('emails.please_fill')
    end
    UserMailer.contact(username, email, inquiry).deliver_later
    redirect_to root_path, :notice => t('contact.successfully_sent_inquiry')
  end

  def flush_cache
    REDIS.flushall
    redirect_to admin_path, :notice => t('admin.flushed_cache')
  end

  def complete_steam_register
    return if params[:action] == 'finish_steam' || !request.get?
    @user = current_user
    if @user && @user.provider == 'steam' && (@user.email.end_with?("@steam-provider.com") || @user.username.start_with?('SteamUser'))
      redirect_to finish_steam_path, :notice => t('steam.please_complete')
    end
  end

  def finish_steam
    @user = current_user
    redirect_to root_path, :notice => t('steam.already_complete') unless (@user.provider == 'steam' && (@user.email.end_with?("@steam-provider.com") || @user.username.start_with?('SteamUser')))
  end
  
  def after_sign_in_path_for(resource)
    root_path
  end

  def news
    key = 'UNTURNED:news'
    result = REDIS.get(key)
    if !result
      response = HTTParty.get('http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=304930&count=1&format=json')
      result = JSON.parse(response.body)
      response_json = {}
      article = result['appnews']['newsitems'][0]
      response_json['title'] = article['title']
      response_json['url'] = article['url']
      response_json['content'] = article['contents'].bbcode_to_html.gsub(/[\r\n]+/, "<br>").gsub('http://', '//')
      result = response_json.to_json
      REDIS.set(key, result)
      REDIS.expire(key, 10.minutes)
    else
      result = JSON.load(result)
    end
    respond_to do |format|
      format.json { render json: result }
    end
  end

  def ban_user
    username = params[:username]
    if user = User.find_by(username: username)
      user.banned = true
      user.save
      redirect_to admin_users_path, :notice => t('admins.listings.users.banned', username: user.username)
    else
      return redirect_to admin_users_path, :alert => t('emails.not_found')
    end   
  end

  def unban_user
    username = params[:username]
    if user = User.find_by(username: username)
      user.banned = false
      user.save
      redirect_to admin_users_path, :notice => t('admins.listings.users.unbanned', username: user.username)
    else
      return redirect_to admin_users_path, :alert => t('emails.not_found')
    end   
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
