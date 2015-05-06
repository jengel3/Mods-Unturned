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
      UserMailer.comment(@comment).deliver_later
      redirect_to @submission, :notice => t('comments.successfully_saved')
    else
      redirect_to @submission, :alert => t('comments.save_failed')
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
    redirect_to @submission, :notice => t('comments.successfully_deleted')
  end

  def restore
    @comment.restore
    redirect_to @submission, :notice => t('comments.successfully_restored')
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
