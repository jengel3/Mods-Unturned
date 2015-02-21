class OmniauthCallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def steam
    @user = User.from_steam(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user
      redirect_to finish_steam, :notice => "Complete your account before continuing"
    else
      session["devise.steam_data"] = request.env["omniauth.auth"].except('extra')
      redirect_to new_user_registration_url
    end
  end
end
