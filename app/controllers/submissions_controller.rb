class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :deny, :approve]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny]
  before_filter :verify_manager, only: [:edit, :destroy, :update]

  def index
    @type = params[:type] ||= "Asset"
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
      assets.each { |asset| @assets << asset if asset.ready? }
      @levels = Array.new
      levels.each { |level| @levels << level if level.ready? }
    end
    @submissions = Submission.all
  end

  def show
    respond_with(@submission)
  end

  def new
    @submission = Submission.new
    respond_with(@submission)
  end

  def edit
  end

  def create
    @submission = Submission.new(submission_params)
    current_user.submissions << @submission
    @submission.save
    respond_with(@submission)
  end

  def update
    @submission.update(submission_params)
    respond_with(@submission)
  end

  def destroy
    @submission.destroy
    redirect_to submissions_path
  end

  private
    def set_submission
      @submission = Submission.find(params[:id])
    end

    def submission_params
      params.require(:submission).permit(:name, :downloads, :body, :type)
    end
end
