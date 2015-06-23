class Blog::PostsController < ApplicationController
	before_filter :set_post, only: [:edit, :update, :show, :destroy]
	before_filter :authenticate_user!, only: [:new, :edit, :create, :destroy]

	def index
		@posts = Blog::Post.all
	end

	def new
		@post = Blog::Post.new
	end

	def edit
	end

	def show
	end

	def create
		@post = Blog::Post.new(post_params)
		current_user.blog_posts << @post
		if @post.save
			redirect_to @post, notice: "Successfully saved a blog post."
		else
			render 'edit', alert: "Please correct the outstanding issues and save the blog post again."
		end
	end

	def update
		if @post.update!(post_params)
			redirect_to @post, notice: "Successfully updated a blog post."
		else
			render 'edit', alert: "Please correct the outstanding issues and save the blog post again."
		end
	end

	def destroy
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
