class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :deny, :approve, :download, :favorite]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny, :favorite]
  before_filter :require_admin, only: [:approve, :deny, :favorite]
  before_filter :verify_manager, only: [:edit, :destroy, :update]

  def index
    if params[:user]
      @user = User.where(:username => params[:user]).first
      if !@user
        return redirect_to root_path
      end
      @submissions = Submission.where(:user => @user)
      @submissions = if params[:sort] == "newest" || !params[:sort]
        @submissions.desc(:approved_at)
      elsif params[:sort] == "popular"
        @submissions = @submissions.desc(:download_count)
      elsif params[:sort] == "updated"
        @submissions = @submissions.desc(:last_update)
      end
      @submissions = @submissions.page(params[:page]).per(20)
    else
      @type = params[:type]
      projects = Submission.all
      if params[:type] && params[:type] != "all"
        projects = projects.where(:type => type_for(@type))
      else
        @type = "All"
      end
      projects = if params[:sort] == "newest" || !params[:sort]
        projects.desc(:approved_at)
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
  
  def favorite
    @submission.last_favorited = Time.now
    @submission.save
    redirect_to @submission
  end

  def download
    latest = @submission.latest_download
    # unless request.ip == @submission.user.last_sign_in_ip
    @submission.add_download(request.ip, current_user, latest)
    # end
    send_file latest.upload.path
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
    params.require(:submission).permit(:name, :uploads, :body, :type)
  end
end
