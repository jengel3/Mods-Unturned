class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    @images = Image.all
  end

  def show
  end

  def new
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path, alert: 'No permission.' unless can_manage(@submission)
    @image = @submission.images.build
  end

  def edit
    return redirect_to root_path, alert: 'No permission.' unless can_manage(@image.submission)
  end

  def create
    @submission = Submission.find(params[:submission_id])
    return redirect_to root_path, alert: 'No permission.' unless can_manage(@submission)
    @image = Image.new(image_params)
    @submission.images << @image
    if @image.save
      redirect_to @submission, :notice => "Successfully created a new submission."
    else
      render 'edit', :alert => "Unable to upload image, see errors below."
    end
  end

  def update
    return redirect_to root_path, alert: 'No permission.' unless can_manage(@image.submission)
    @image.update(image_params)
  end

  def destroy
    return redirect_to root_path, alert: 'No permission.' unless can_manage(@image.submission)
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
