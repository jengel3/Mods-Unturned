class ModerationController < ApplicationController
  def home
    @downloads = Download.where(:denied => false).where(:approved => false)
  end
end
