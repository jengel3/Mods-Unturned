class Users::OmniauthCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def steam
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.steam_data"] = request.env["omniauth.auth"].except('extra')
      redirect_to new_user_registration_url, :notice => "Unable to use this Steam account."
    end
  end
end
