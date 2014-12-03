class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny]
  before_filter :require_admin, only: [:approve, :deny]
  
  def approve
    @upload.approved = true
    @upload.save
    redirect_to moderation_path
  end

  def deny
    @upload.denied = true
    @upload.save
    redirect_to moderation_path
  end

  def index
    @submission = Submission.find(params[:submission_id])
    @uploads = @submission.uploads
    respond_with(@uploads)
  end

  def show
    respond_with(@upload)
  end

  def new
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path unless can_manage(@submission)
    @upload = @submission.uploads.build
    respond_with(@upload)
  end

  def edit
    return redirect_to root_path unless can_manage(@upload.submission)
  end

  def create
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path unless can_manage(@submission)
    @upload = Upload.new(upload_params)
    @submission.uploads << @upload
    if @upload.save
      redirect_to @submission
    else
      render 'edit'
    end
  end

  def update
    return redirect_to root_path unless can_manage(@upload.submission)
    @upload.update(upload_params)
    respond_with(@upload)
  end

  def destroy
    return redirect_to root_path unless can_manage(@upload.submission)
    @upload.destroy
    respond_with(@upload)
  end

  private
    def set_upload
      @upload = Upload.find(params[:id || :upload_id])
    end

    def upload_params
      params.require(:upload).permit(:upload, :name, :version)
    end
end
