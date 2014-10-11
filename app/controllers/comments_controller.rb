class CommentsController < ApplicationController
  def create
    @submission = Submission.find(params[:submission_id])
    @user = current_user
    @comment = Comment.new(comment_params)
    @user.comments << @comment
    @submission.comments << @comment
    if @comment.save
      redirect_to @submission, :notice => "Your comment has been successfully saved."
    else
      redirect_to @submission, :alert => "You did not create a valid comment."
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text)
  end
end
