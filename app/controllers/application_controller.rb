class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_redirect, if: :devise_controller?

  def check_redirect
    puts "CONTROLLER: #{params[:controller]} AND ACTION: #{params[:action]}"
    redirect_to new_user_registration_path if params[:controller] == 'devise/sessions' and (params[:action] == 'new' || params[:action] == 'edit')
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
