class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :deny, :approve, :download]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny]
  before_filter :verify_manager, only: [:edit, :destroy, :update]

  def index
    if params[:user]
      @user = User.where(:username => params[:user]).first
      if !@user
        return redirect_to root_path
      end
      @submissions = Submission.where(:user => @user)
      @submissions = if params[:sort] == "newest" || !params[:sort]
        @submissions.desc(:created_at)
      elsif params[:sort] == "popular"
        @submissions = @submissions.desc(:download_count)
      elsif params[:sort] == "updated"
        @submissions = @submissions.desc(:last_update)
      end
      @submissions = @submissions.page(params[:page]).per(20)
    else
      @type = params[:type]
      projects = Submission.all
      if params[:type]
        projects = projects.where(:type => type_for(@type))
      else
        @type = "All"
      end
      projects = if params[:sort] == "newest" || !params[:sort]
        projects.desc(:created_at)
      elsif params[:sort] == "popular"
        projects = projects.desc(:download_count)
      elsif params[:sort] == "updated"
        projects = projects.desc(:last_update)
      end
      @submissions = Array.new
      projects.each { |submission| @submissions << submission if submission.ready? }
      @submissions = Kaminari.paginate_array(@submissions).page(params[:page]).per(20)
    end
  end

  def download
    unless request.ip == @submission.user.last_sign_in_ip
      @submission.download_count = @submission.download_count + 1
      @submission.save
    end
    send_file @submission.latest_download.download.path
  end

  def show
    if !@submission
      return redirect_to root_path
    end
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
    if type == "models"
      return "Asset"
    elsif type == "levels"
      return "Level"
    else
      return "Level"
    end
  end

  def set_submission
    @submission = Submission.find(params[:id] || params[:submission_id])
  end

  def submission_params
    params.require(:submission).permit(:name, :downloads, :body, :type)
  end
end
