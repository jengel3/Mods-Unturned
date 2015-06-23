class Blog::PostsController < ApplicationController
	before_filter :set_post, only: [:edit, :update, :show, :destroy]
	before_filter :authenticate_user!, only: [:new, :edit, :create, :destroy]

	def index
		@posts = Blog::Post.all
	end

	def new
		redirect_to blog_posts_path unless current_user.can_blog || user_is_admin
		@post = Blog::Post.new
	end

	def edit
		redirect_to blog_posts_path unless (current_user.can_blog && @post.author == current_user) || user_is_admin
	end

	def show
	end

	def create
		redirect_to blog_posts_path unless current_user.can_blog || user_is_admin
		@post = Blog::Post.new(post_params)
		current_user.blog_posts << @post
		if @post.save
			redirect_to @post, notice: "Successfully saved a blog post."
		else
			render 'edit', alert: "Please correct the outstanding issues and save the blog post again."
		end
	end

	def update
		redirect_to blog_posts_path unless (current_user.can_blog && @post.author == current_user) || user_is_admin
		if @post.update!(post_params)
			redirect_to @post, notice: "Successfully updated a blog post."
		else
			render 'edit', alert: "Please correct the outstanding issues and save the blog post again."
		end
	end

	def destroy
		redirect_to blog_posts_path unless (current_user.can_blog && @post.author == current_user) || user_is_admin
		@post.destroy
		redirect_to blog_posts_path, notice: "Successfully deleted a blog post."
	end

	private
	def set_post
		@post = Blog::Post.find(params[:id])
	end

	def post_params
		params.require(:blog_post).permit(:title, :body)
	end
end
