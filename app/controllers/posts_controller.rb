class PostsController < ApplicationController

  def index
    @posts = Post.includes(:user, :liked_users, { :visible_comments => :user }).page(params[:page])
  end

  def show
    @post = Post.find(params[:id])

    if current_user
      all_comments = @post.comments.where("status = ? OR (status = ? AND user_id = ?)", "public", "private", current_user.id).includes(:user)
      @comments = all_comments.select{ |x| x.status == "public" }
      @my_comments = all_comments.select{ |x| x.status == "private" }

    else
      @comments = @post.comments.visible.includes(:user)
    end
  end

  def report
    @posts = Post.all.sort_by{ |post| post.subscriptions.size }.reverse[0,10]
  end

end
