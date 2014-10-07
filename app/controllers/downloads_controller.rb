class DownloadsController < ApplicationController
  before_action :set_download, only: [:show, :edit, :update, :destroy]

  def index
    @submission = Submission.find(params[:submission_id])
    @downloads = @submission.downloads
    respond_with(@downloads)
  end

  def show
    respond_with(@download)
  end

  def new
    @download = Download.new
    respond_with(@download)
  end

  def edit
  end

  def create
    @download = Download.new(download_params)
    @download.save
    respond_with(@download)
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
      params.require(:download).permit(:downloads, :game_version, :version, :changelog, :notes, :type)
    end
end
