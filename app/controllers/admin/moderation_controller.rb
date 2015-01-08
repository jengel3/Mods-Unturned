class Admin::ModerationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  
  def index
    @uploads = Upload.where(:denied => false).where(:approved => false)
  end
end
