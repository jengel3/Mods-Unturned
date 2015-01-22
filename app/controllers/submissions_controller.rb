class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :deny, :approve, :download, :favorite]
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
        @submissions = @submissions.desc(:total_downloads)
      elsif params[:sort] == "updated"
        @submissions = @submissions.desc(:last_update)
      end
      @submissions = @submissions.page(params[:page]).per(20)
    elsif params[:type]
      @type = params[:type]
      projects = Submission.where(:approved_at.exists => true)
      if params[:type] && params[:type] != "all"
        projects = projects.where(:type => type_for(@type))
      else
        @type = "All"
      end
      projects = if params[:sort] == "newest" || !params[:sort]
        projects.desc(:approved_at)
      elsif params[:sort] == "popular"
        projects = projects.desc(:total_downloads)
      elsif params[:sort] == "updated"
        projects = projects.desc(:last_update)
      end
      @submissions = projects.page(params[:page]).per(20)
    elsif params[:search]
      @submissions = Kaminari.paginate_array(Submission.es.search(params[:search][:search], page: params[:page]).results).page(params[:page]).per(20)
    end
    if params[:user]
      @title = params[:user] + "'s" + ' Creations'
    elsif params[:search]
      @title = 'Results'
    else
      @title = @type.singularize.capitalize + ' Creations'
    end
    respond_to do |format|
      format.html
      format.json { @submissions }
      format.rss { render :layout => false }
    end
  end

  def favorite
    @submission.last_favorited = Time.now
    @submission.save
    redirect_to @submission, :notice => "Successfully favorited #{@submission.name}."
  end

  def download
    latest = @submission.latest_download
    request_ip = get_request_ip
    unless request_ip == @submission.user.last_sign_in_ip
      @submission.add_download(request_ip, current_user, latest)
    end
    send_file latest.upload.path
  end

  def show
    if !@submission
      return redirect_to root_path, :alert => "Submission does not exist."
    end
    @comments = @submission.comments.unscoped.all.asc(:created_at).reject(&:new_record?)
  end

  def new
    @submission = Submission.new
  end

  def edit
  end

  def create
    @submission = Submission.new(submission_params)
    current_user.submissions << @submission

    if @submission.save
      redirect_to @submission, :notice => "Successfully created a new submission."
    else
      render 'edit'
    end
  end

  def update
    respond_to do |format|
      if @submission.update!(submission_params)
        format.html { redirect_to @submission }
        format.json { respond_with_bip(@submission) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@submission) }
      end
    end
  end

  def destroy
    @submission.destroy
    redirect_to submissions_path, :notice => "Successfully deleted a submission."
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
