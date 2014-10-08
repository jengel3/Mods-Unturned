class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    @images = Image.all
    respond_with(@images)
  end

  def show
    respond_with(@image)
  end

  def new
    @submission = Submission.find(params[:submission_id])
    @image = @submission.images.build
    respond_with(@image)
  end

  def edit
  end

  def create
    @image = Image.new(image_params)
    @submission = Submission.find(params[:submission_id])
    @submission.images << @image
    if @image.save
      redirect_to @submission
    else
      render 'edit'
    end
  end

  def update
    @image.update(image_params)
    respond_with(@image)
  end

  def destroy
    @image.destroy
    respond_with(@image)
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:image, :location)
    end
end
