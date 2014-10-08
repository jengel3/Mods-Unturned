class DownloadsController < ApplicationController
  before_action :set_download, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

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
    @download = @submission.downloads.build
    respond_with(@download)
  end

  def edit
  end

  def create
    @submission = Submission.find(params[:submission_id])
    @download = @submission.downloads.create(download_params)
    if @download.save
      redirect_to @submission
    else
      render 'edit'
    end
  end

  def update
    @download.update(download_params)
    respond_with(@download)
  end

  def destroy
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
