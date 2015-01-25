class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
   super
   UserMailer.welcome(@user).deliver unless @user.invalid?
 end
 protected

 def update_resource(resource, params)
  resource.update_without_password(params)
end
end  