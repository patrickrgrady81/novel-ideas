class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  def index
    @posts = Post.all.order("created_at DESC")
  end

  def new
    @post = helpers.current_user.posts.build
  end

  def create
    @post = helpers.current_user.posts.build(post_params)
    if @post.save
      redirect_to @post 
    else
      render 'new'
    end
  end

  def show
    
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post 
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to '/'
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def find_post
    @post = Post.find(params[:id])
  end
end