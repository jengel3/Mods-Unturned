class CommentsController < ApplicationController
  before_filter :set_comment, only: [:destroy, :restore, :show]
  before_filter :require_admin, only: [:restore]

  def create
    @submission = Submission.find(params[:submission_id])
    return redirect_to new_user_registration_path unless @user = current_user
    @comment = Comment.new(comment_params)
    @user.comments << @comment
    @submission.comments << @comment
    if @comment.save
      redirect_to @submission, :notice => "Your comment has been successfully saved."
    else
      redirect_to @submission, :alert => "You did not create a valid comment."
    end
  end

  def show
    redirect_to @comment.submission
  end

  def destroy
    unless current_user && @comment.user = current_user
      return require_admin
    end
    @comment.destroy
    redirect_to @submission, :notice => "Successfully deleted a comment."
  end

  def restore
    @comment.restore
    redirect_to @submission, :notice => "Successfully restored a comment."
  end

  private
  def set_comment
    @comment = Comment.unscoped.all.find(params[:id] || params[:comment_id])
    @submission = @comment.submission
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
