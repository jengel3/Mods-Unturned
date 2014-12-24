class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :is_maintenance

  def is_maintenance
    if MAINTENANCE
      return redirect_to action: 'maintenance', controller: 'application' unless params[:action] == 'maintenance' || user_is_admin
    end
  end

  def maintenance
    return redirect_to root_path unless MAINTENANCE
  end

  def about
  end

  def contact
    form = params[:contact]
    email = form[:email]
    username = form[:username]
    inquiry = form[:inquiry]
    if email.empty? || username.empty? || inquiry.empty?
      return redirect_to root_path, :alert => "Please fill in all fields."
    end
    UserMailer.contact(username, email, inquiry).deliver
    redirect_to root_path, :notice => "Successfully sent an inquiry to Mods Unturned."
  end
  
  def after_sign_in_path_for(resource)
    root_path
  end

  def news
    response = HTTParty.get('http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=304930&count=1&format=json')
    respond_to do |format|
      format.json { render json: response }
    end
  end

  def tohtml
    input = request.body.read
    respond_to do |format|
      format.json { render json: input.bbcode_to_html.to_json }
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
