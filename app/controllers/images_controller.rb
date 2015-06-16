class ImagesController < ApplicationController
  before_action :set_image, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:edit, :create, :destroy]

  before_filter :check_ban, only: [:create, :destroy]

  def edit
    return redirect_to root_path, alert: t('users.no_permission') unless can_manage(@image.submission)
  end

  def create
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path, alert: t('users.no_permission') unless can_manage(@submission)
    @image = Image.new(image_params)
    @image.submission = @submission
    if @image.save
      redirect_to @submission, :notice => t('images.successfully_created')
    else
      render 'edit', :alert => t('images.unable_to_upload')
    end
  end

  def destroy
    return redirect_to root_path, alert: t('users.no_permission') unless can_manage(@image.submission)
    @image.destroy
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:image, :location)
    end
end
