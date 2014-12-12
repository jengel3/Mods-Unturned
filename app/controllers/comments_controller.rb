class CommentsController < ApplicationController
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

  def destroy
    @comment = Comment.find(params[:id])
    unless current_user && @comment.user = current_user
      return require_admin
    end
    @comment = Comment.find(params[:id])
    @submission = @comment.submission
    @comment.destroy
    redirect_to @submission
  end

  private
  def comment_params
    params.require(:comment).permit(:text)
  end
end
