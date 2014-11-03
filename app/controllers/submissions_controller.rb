class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :deny, :approve]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny]
  before_filter :verify_manager, only: [:edit, :destroy, :update]

  def index
    @type = params[:type] ||= "assets"
    projects = Submission.where(:type => type_for(@type)).desc(:created_at)
    if params[:user]
      @user = User.where(:username => params[:user]).first
      projects = projects.where(:user => @user)
    end

    if @user and @user == current_user
      @submissions = projects
    else
      @submissions = Array.new
      projects.each { |submission| @submission << submission if submission.ready? }
    end
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
    def type_for(type)
      if type == "assets"
        return "Asset"
      elsif type == "levels"
        return "Level"
      else
        return "Level"
      end
    end

    def set_submission
      @submission = Submission.find(params[:id])
    end

    def submission_params
      params.require(:submission).permit(:name, :downloads, :body, :type)
    end
end
