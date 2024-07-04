class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :update, :destroy]
  skip_before_action :check_authenticate, only: [:index, :show]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    posts = Post.all.includes(:user)

    posts = posts.where("title LIKE '%#{params[:title]}%'") if params[:title].present?

    posts = posts.order(id: :desc)
    posts = posts.page(page).per(per_page)

    render json: {
      meta: {
        current_page: posts.current_page,
        next_page: posts.next_page,
        prev_page: posts.prev_page,
        total_pages: posts.total_pages,
        total_count: posts.total_count
      },
      posts: ActiveModelSerializers::SerializableResource.new(posts)
    }
  end

  def create
    post = Post.new(post_params)
    post.user = @current_user

    if post.save
      render json: post, status: :created
    else
      render json: { errors: 'Bad Request' }, status: :bad_request
    end
  end

  def show
    render json: @post
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: 'Bad Request' }, status: :bad_request
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private
  def set_post
    begin
      @post = Post.find(params[:id])
    rescue
      render json: { errors: 'Not Found' }, status: :not_found
    end
  end

  def post_params
    params.permit(:title, :body)
  end

end
