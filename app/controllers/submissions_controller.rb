class SubmissionsController < ApplicationController
  include SubmissionsHelper
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :deny, :approve, :download, :favorite]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny, :favorite]
  before_filter :require_admin, only: [:approve, :deny, :favorite]
  before_filter :verify_manager, only: [:edit, :destroy, :update]

  before_filter :check_ban, only: [:create, :destroy, :update]

  def index
    @category = params[:category]
    @submissions = Submission.valid.where(:type => @category)
    @submissions = if params[:sort] == "newest" || !params[:sort]
      @submissions.desc(:approved_at)
    elsif params[:sort] == "popular"
      @submissions = @submissions.desc(:total_downloads)
    elsif params[:sort] == "updated"
      @submissions = @submissions.desc(:last_update)
    end
    @submissions = @submissions.page(params[:page]).per(20)
  end

  def search
    puts @submissions, "Isbvndfikvdfv"
    @submissions = search_submissions
  end

  def favorite
    @submission.last_favorited = Time.now
    @submission.save
    redirect_to @submission, :notice => t('submissions.successfully_favorited', name: @submission.name)
  end

  def download
    latest = @submission.latest_download
    request_ip = get_request_ip
    unless request_ip == @submission.user.last_sign_in_ip
      @submission.add_download(request_ip, current_user, latest)
    end
    send_file latest.upload.path, :length => File.size(latest.upload.path)
  end

  def show
    if !@submission
      return redirect_to root_path, :alert => t('submissions.does_not_exist')
    end
    images = @submission.thumbnails.sort_by { |i| [i.location[ -1..-1 ], i] }

    @thumbnails = {}
    previous = 0
    images.each do |image|
      while image.num != previous + 1 do
        @thumbnails[previous + 1] = nil
        previous += 1
      end
      @thumbnails[previous] = image
      previous += 1
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
      redirect_to @submission, :notice => t('submissions.successfully_created')
    else
      render 'edit'
    end
  end

  def update
    respond_to do |format|
      if @submission.update!(submission_params)
        format.html { redirect_to @submission }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @submission.destroy
    redirect_to projects_path(:type => "all"), :notice => t('submissions.successfully_deleted')
  end

  private
  def set_submission
    @submission = Submission.find(params[:id] || params[:submission_id])
  end

  def submission_params
    params.require(:submission).permit(:name, :uploads, :body, :type)
  end
end
