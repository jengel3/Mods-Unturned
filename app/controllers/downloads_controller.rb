class DownloadsController < ApplicationController
  before_action :set_download, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny]
  before_filter :require_admin, only: [:approve, :deny]
  
  def approve
    @download = Download.find(params[:download_id])
    @download.approved = true
    @download.save
    redirect_to moderation_path
  end

  def deny
    @download = Download.find(params[:download_id])
    @download.denied = true
    @download.save
    redirect_to moderation_path
  end

  def index
    @submission = Submission.find(params[:submission_id])
    @downloads = @submission.downloads
    respond_with(@downloads)
  end

  def show
    respond_with(@download)
  end

  def new
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path unless can_manage(@submission)
    @download = @submission.downloads.build
    respond_with(@download)
  end

  def edit
    return redirect_to root_path unless can_manage(@download.submission)
  end

  def create
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path unless can_manage(@submission)
    @download = Download.new(download_params)
    @submission.downloads << @download
    if @download.save
      redirect_to @submission
    else
      render 'edit'
    end
  end

  def update
    return redirect_to root_path unless can_manage(@download.submission)
    @download.update(download_params)
    respond_with(@download)
  end

  def destroy
    return redirect_to root_path unless can_manage(@download.submission)
    @download.destroy
    respond_with(@download)
  end

  private
    def set_download
      @download = Download.find(params[:id])
    end

    def download_params
      params.require(:download).permit(:download, :name, :downloads, :game_version, :version, :changelog, :notes, :type)
    end
end
