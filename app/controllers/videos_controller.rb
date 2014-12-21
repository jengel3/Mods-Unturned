class VideosController < ApplicationController
  before_filter :set_video, only: [:destroy]
  before_filter :authenticate_user!

  def create
    @video = Video.new(video_params)
    @submission = Submission.find(params[:submission_id])
    @submission.videos << @video
    if @video.save
      redirect_to @video.submission # Success
    else
      redirect_to @video.submission # Error message
    end
  end

  def destroy
    if can_manage(@video.submission)
      @video.submission.destroy
    else
      redirect_to submission_path(@video.submission)
    end
  end

  private
  def video_params
    params.require(:video).permit(:url, :thumbnail)
  end

  def set_video
    @video = Video.find(params[:id] || params[:video_id])
  end
end
