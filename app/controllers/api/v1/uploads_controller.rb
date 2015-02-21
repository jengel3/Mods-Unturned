class Api::V1::UploadsController < ApplicationController
  include ActionController::ImplicitRender
  include SubmissionsHelper
  def index
    @submission = Submission.where(:id => params[:submission_id]).first
    return render json: { error: 'Resource not found' }, status: :not_found unless @submission
    @uploads = @submission.uploads
    @uploads = @uploads.page(params[:page]).per(10)
    @page = params[:page]
    @max = @uploads.total_pages
    if !@uploads.any?
      render json: { error: 'No resources found' }, status: :no_content 
    end
  end

  def show
    @submission = Submission.where(:id => params[:submission_id]).first
    return render json: { error: 'Resource not found' }, status: :not_found unless @submission
    unless @upload = @submission.uploads.where(:id => params[:id]).first
      return render json: { error: 'Resource not found' }, status: :not_found 
    end
  end

  def stats
    stats = group_by Upload, 'created_at'
    render json: stats.to_json 
  end
end
