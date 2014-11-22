class SessionsController < Devise::SessionsController
  def new
    redirect_to new_user_registration_path
  end
end