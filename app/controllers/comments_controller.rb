class CommentsController < ApplicationController
  def show
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new()
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    # raise @comment.inspect
    if @comment.save
      redirect_to post_path(@post.id)
    else
      render new_post_comment_path(@post, @comment)
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private 

  def comment_params 
    params.require(:comment).permit(:title, :content)
  end
end
