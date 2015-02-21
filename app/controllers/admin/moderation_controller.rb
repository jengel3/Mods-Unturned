class Admin::ModerationController < Admin::BaseController
  def index
    @uploads = Upload.where(:denied => false).where(:approved => false)
  end
end
