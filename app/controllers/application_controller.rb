class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :is_maintenance
  before_filter :require_admin, only: [:flush_cache]
  before_filter :complete_steam_register

  def is_maintenance
    if MAINTENANCE
      return redirect_to action: 'maintenance', controller: 'application' unless params[:action] == 'maintenance' || user_is_admin || ['104.181.238.3', '24.188.223.82'].include?(get_request_ip)
    end
  end

  def maintenance
    return redirect_to root_path unless MAINTENANCE
  end

  def unsubscribe
    email = params[:email]
    user = User.where(email: email).first
    if user
      user.accepts_emails = false
      user.save
      return redirect_to root_path, :notice => 'Successfully unsubscribed from emails.'
    end
    return redirect_to root_path, :alert => 'Email address not found'
  end
  
  def contact
    form = params[:contact]
    email = form[:email]
    username = form[:username]
    inquiry = form[:inquiry]
    if email.empty? || username.empty? || inquiry.empty?
      return redirect_to root_path, :alert => "Please fill in all fields."
    end
    UserMailer.contact(username, email, inquiry).deliver_now
    redirect_to root_path, :notice => "Successfully sent an inquiry to Mods Unturned."
  end

  def flush_cache
    REDIS.flushall
    redirect_to admin_path, :notice => "Successfully flushed cache"
  end

  def complete_steam_register
    return if params[:action] == 'finish_steam' || !request.get?
    @user = current_user
    if @user && @user.provider == 'steam' && (@user.email.end_with?("@steam-provider.com") || @user.username.start_with?('SteamUser'))
      redirect_to finish_steam_path, :notice => "Complete your account before continuing"
    end
  end

  def finish_steam
    @user = current_user
    redirect_to root_path, :notice => "Your Steam registration is already complete." unless (@user.provider == 'steam' && (@user.email.end_with?("@steam-provider.com") || @user.username.start_with?('SteamUser')))
  end
  
  def after_sign_in_path_for(resource)
    root_path
  end

  def news
    response = HTTParty.get('http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=304930&count=1&format=json')
    result = JSON.parse(response.body)
    response_json = {}
    article = result['appnews']['newsitems'][0]
    response_json['title'] = article['title']
    response_json['url'] = article['url']
    response_json['content'] = article['contents'].bbcode_to_html.gsub(/[\r\n]+/, "<br>").gsub('http://', '//')
    respond_to do |format|
      format.json { render json: response_json.to_json }
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
