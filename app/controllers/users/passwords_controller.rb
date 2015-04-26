class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_user_session_path
  end
end