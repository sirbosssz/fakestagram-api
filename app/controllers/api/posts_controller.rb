class Api::PostsController < Api::ApiController
  skip_before_action :set_current_user, only: [ :index, :show ]
  before_action :get_my_post_by_id, only: [ :update, :destroy ]

  def index
    posts = Post.all
    render json: posts.as_json
  end

  def by_user
    posts = current_user.posts
    render json: posts
  end

  def create
    raise ApiBadreqError.new("image_url is required") if params[:post][:image_url].blank?

    post = Post.new(params_post)
    post.user = current_user
    post.save

    render json: post
  end

  def show
    post = Post.find_by_id(params[:id])
    raise ApiNotfoundError.new("post not found") if post.blank?
    render json: post
  end

  def update
    post = @post
    post.update(params_post)
    render json: post
  end

  def destroy
    post = @post
    post.destroy
    render json: { message: "delete successfully" }
  end

  private

  def get_my_post_by_id
    @post = current_user.posts.find_by_id(params[:id])
    raise ApiBadreqError.new("post not found or you are not post owner") if @post.blank?
  end

  def params_post
    params.require(:post).permit(:image_url, :description)
  end
end
