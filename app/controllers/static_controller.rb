class StaticController < ApplicationController
  def index
    assets = Submission.where(:type => "Asset").desc(:created_at)
    levels = Submission.where(:type => "Level").desc(:created_at)

    if params[:user]
      @user = User.where(:username => params[:user]).first
      assets = assets.where(:user => @user)
      levels = levels.where(:user => @user)
    end

    if @user and @user == current_user
      @assets = assets
      @levels = levels
    else
      @assets = Array.new
      assets.each { |asset| @assets << asset if asset.valid? }
      @levels = Array.new
      levels.each { |level| @levels << level if level.valid? }
    end
  end
end
