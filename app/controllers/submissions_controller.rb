class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :deny, :approve]
  respond_to :html, :xml, :json
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy, :approve, :deny]

  def index
    @submissions = if !params[:user]
      Submission.all
    else
      Submission.where(:user => {:username => params[:user]})
    end
    respond_with(@submissions)
  end

  def show
    respond_with(@submission)
  end

  def new
    @submission = Submission.new
    respond_with(@submission)
  end

  def edit
  end

  def create
    @submission = Submission.new(submission_params)
    current_user.submissions << @submission
    @submission.save
    respond_with(@submission)
  end

  def update
    @submission.update(submission_params)
    respond_with(@submission)
  end

  def destroy
    @submission.destroy
    respond_with(@submission)
  end

  private
    def set_submission
      @submission = Submission.find(params[:id])
    end

    def submission_params
      params.require(:submission).permit(:name, :downloads, :body, :type)
    end
end
