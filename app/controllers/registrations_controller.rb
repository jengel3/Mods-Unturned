class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
   super
   UserMailer.welcome(@user).deliver unless @user.invalid?
 end
end  