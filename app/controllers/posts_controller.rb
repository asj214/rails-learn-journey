class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :update, :destroy]
  skip_before_action :check_authenticate, only: [:index, :show]

  def index
    posts = Post.all
    # render plain: 'posts#index'
    render json: posts
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
