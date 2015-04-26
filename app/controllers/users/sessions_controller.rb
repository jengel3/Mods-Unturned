class Users::SessionsController < Devise::SessionsController  
  respond_to :json

  def new
    redirect_to new_user_registration_path
  end
end  