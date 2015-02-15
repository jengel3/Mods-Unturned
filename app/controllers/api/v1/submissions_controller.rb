class Api::V1::SubmissionsController < ApplicationController
  include ActionController::ImplicitRender
  def index
    @type = type_for(params[:type])
    @sort = sort_for(params[:sort])
    @submissions = if params[:approved] == "0"
      Submission.all
    else
      Submission.valid
    end

    unless @type == 'All'
      @submissions = @submissions.where(:type => @type)
    end

    @submissions = @submissions.desc(@sort)
    @submissions = @submissions.page(params[:page]).per(20)
    if !@submissions.any?
      render json: { error: 'No resources found' }, status: :no_content 
    end
  end

  def show
    unless @submission = Submission.find(params[:id])
      return render json: { error: 'Resource not found' }, status: :not_found 
    end
    count = params[:comments].to_i ||= 10
    @comments = @submission.comments.limit(count)
    count = params[:uploads].to_i ||= 5
    @uploads = @submission.uploads.where(:approved => true).desc(:created_at).limit(count)
  end

  private
  def type_for(type)
    case type.downcase
    when "models", "assets"
      "Asset"
    when "levels", "maps"
      "Level"
    else
      "All"
    end
  end

  def sort_for(sort)
    case sort.downcase
    when "newest"
      "total_downloads"
    when "updated"
      "last_update"
    when "popular"
      "total_downloads"
    else
      "approved_at"
    end
  end
end
