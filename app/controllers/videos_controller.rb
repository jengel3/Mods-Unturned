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
      return redirect_to @submission, :alert => t('videos.id_not_found')
    end
    if @video.save
      @submission.videos << @video
      current_user.submitted_videos << @video
      redirect_to @video.submission, :notice => t('videos.successfully_added', name: @submission.name)
    else
      redirect_to @video.submission, :alert => t('videos.already_added', name: @submission.name)
    end
  end

  def destroy
    @submission = @video.submission
    if can_manage(@video.submission)
      @video.destroy
    end
    redirect_to submission_path(@video.submission), :notice => t('videos.successfully_deleted')
  end

  private
  def video_params
    params.require(:video).permit(:url, :thumbnail)
  end

  def set_video
    @video = Video.find(params[:id] || params[:video_id])
  end
end
