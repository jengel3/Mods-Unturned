class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy, :approve, :deny, :download]
  respond_to :html
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny]
  before_filter :require_admin, only: [:approve, :deny]
  
  def download
    request_ip = get_request_ip
    @submission = @upload.submission
    unless request_ip == @submission.user.last_sign_in_ip
      @submission.add_download(request_ip, current_user, latest)
    end
    send_file @upload.upload.path
  end

  def approve
    @upload.approved = true
    if !@upload.save
      @upload.destroy
      return
    end
    UserMailer.approved(@upload).deliver_later
    respond_to do |format|
      format.json { render json: @upload.errors.to_json }
    end
  end

  def deny
    @upload.denied = true
    if !@upload.save
      @upload.destroy
      return
    end
    request_data = JSON.parse(request.body.read)
    reason = request_data['reason']
    UserMailer.denied(@upload, reason).deliver_later
    respond_to do |format|
      format.json { render json: @upload.errors.to_json }
    end
  end

  def index
    @submission = Submission.find(params[:submission_id])
    @uploads = @submission.uploads
  end

  def show
    redirect_to @upload.submission
  end

  def new
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path, :alert => t('users.no_permission') unless can_manage(@submission)
    @upload = @submission.uploads.build
  end

  def edit
    return redirect_to root_path, :alert => t('users.no_permission') unless can_manage(@upload.submission)
  end

  def create
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path unless can_manage(@submission)
    @upload = Upload.new(upload_params)
    @submission.uploads << @upload
    respond_to do |format|
      if @upload.save
        flash[:notice] = t('uploads.was_saved')
        format.html { redirect_to(@submission) }
      else
        flash[:alert] = t('uploads.unable_to_save')
        format.html { render action: "edit" }
      end
    end
  end

  def update
    return redirect_to root_path, :alert => t('users.no_permission') unless can_manage(@upload.submission)
    @upload.update(upload_params)
  end

  def destroy
    return redirect_to root_path, :alert => t('users.no_permission') unless can_manage(@upload.submission)
    @upload.destroy
  end

  private
  def set_upload
    @upload = Upload.find(params[:upload_id])
  end

  def upload_params
    params.require(:upload).permit(:upload, :name, :version)
  end
end
