# frozen_string_literal: true

class PostsController < ApplicationController
  # Exceptions errors

  # Exceptions errors
  # the last "RESCUE_FROM" is the one with the highest priority

  rescue_from Exception do |e|
    # log.error "#{e.message}"
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from 'ActiveRecord::RecordInvaliddo' do |e|
    render json: { error: e.message }, status: :internal_error
  end

  # GET /posts
  def index
    @posts = Post.where(published: true)
    render json: @posts, status: :ok
  end

  # GET /posts/{id}
  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end

  # POST /posts
  def create
    @post = Post.create!(create_params)

    render json: @post, status: :created
  end

  # PUT /posts/{id}
  def update
    @post = Post.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end
