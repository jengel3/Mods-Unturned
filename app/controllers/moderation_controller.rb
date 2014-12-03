class ModerationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  
  def home
    @uploads = Upload.where(:denied => false).where(:approved => false)
  end
end
