class Api::V1::CommentsController < ApplicationController
  include ActionController::ImplicitRender
  include SubmissionsHelper
  def index
    @submission = Submission.where(:id => params[:submission_id]).first
    return render json: { error: 'Resource not found' }, status: :not_found unless @submission
    @comments = @submission.comments
    @comments = @comments.page(params[:page]).per(20)
    @page = params[:page]
    @max = @comments.total_pages
    if !@comments.any?
      render json: { error: 'No resources found' }, status: :no_content 
    end
  end

  def show
    @submission = Submission.where(:id => params[:submission_id]).first
    return render json: { error: 'Resource not found' }, status: :not_found unless @submission
    unless @comment = @submission.comments.where(:id => params[:id]).first
      return render json: { error: 'Resource not found' }, status: :not_found 
    end
  end

  def stats
    stats = group_by Comment, 'created_at'
    render json: stats.to_json 
  end
end
