class ModerationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_admin
  
  def home
    @downloads = Download.where(:denied => false).where(:approved => false)
  end
end
