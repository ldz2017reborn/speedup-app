class PostsController < ApplicationController

  def index
    @posts = Post.includes(:user, :liked_users, { :visible_comments => :user }).page(params[:page])

    post_ids = @posts.map{ |p| p.id } #订阅数
    @subscriptions_count = Post.where( :id => post_ids ).joins(:subscriptions).group("posts.id").count
  end
    # @subscriptions_count 这个变量是个 Hash，键是 post ID，值是订阅数，例如 {403=>59, 404=>89, 405=>10, 406=>93, 407=>10, 408=>47, 409=>90, 410=>78, 411=>79, 412=>43, 413=>58, 414=>13, 415=>61, 416=>76, 417=>97, 418=>59, 419=>41, 420=>68, 421=>44, 422=>44, 423=>85, 424=>95, 425=>12, 426=>54, 427=>78}
    
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
    @posts = Post.includes(:user).joins(:subscriptions).group("posts.id").select("posts.*, COUNT(subscriptions.id) as subscriptions_count").order("subscriptions_count DESC").limit(10)
  end

end
