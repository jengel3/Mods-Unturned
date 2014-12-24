class VideosController < ApplicationController
  before_filter :set_video, only: [:destroy]
  before_filter :authenticate_user!

  def create
    @video = Video.new(video_params)
    @submission = Submission.find(params[:submission_id])
    thumbnail = @video.get_thumbnail
    if thumbnail
      @video.thumbnail = thumbnail
    else
      return redirect_to @submission
    end
    if @video.save
      @submission.videos << @video
      current_user.submitted_videos << @video
      redirect_to @video.submission # Success
    else
      redirect_to @video.submission # Error message
    end
  end

  def destroy
    @submission = @video.submission
    if can_manage(@video.submission)
      @video.destroy
    end
    redirect_to submission_path(@video.submission)
  end

  private
  def video_params
    params.require(:video).permit(:url, :thumbnail)
  end

  def set_video
    @video = Video.find(params[:id] || params[:video_id])
  end
end
