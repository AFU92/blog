# frozen_string_literal: true

require 'rails_helper'
# require 'byebug'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts is empty' do
    it 'should return OK' do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end

    describe 'Search' do
      let!(:world) { create(:published_post, title: 'Hello world') }
      let!(:rails) { create(:published_post, title: 'Hello Rails Developer') }
      let!(:dev) { create(:published_post, title: 'Backend Developer') }

      it 'should filter post by title' do 
        get '/posts?search=Hello'
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(2)
        expect(payload.map { |p| p['id'] }.sort).to eq([world.id, rails.id].sort)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'With data in the database' do
    # describe "GET /posts is successfully"

    let!(:posts) { create_list(:post, 10, published: true) }

    it 'should return all the published posts' do
      # byebug
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /post/{id}' do
    let!(:post) { create(:post) }

    it 'should return a post' do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['published']).to eq(post.published)
      expect(payload['content']).to eq(post.content)
      expect(payload['autor']['name']).to eq(post.user.name)
      expect(payload['autor']['email']).to eq(post.user.email)
      expect(payload['autor']['id']).to eq(post.user.id)
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /posts' do
    let!(:user) { create(:user) }

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          published: false,
          user_id: user.id
        }
      }

      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to_not be_nil
      expect(response).to have_http_status(:created)
    end

    it 'should return error message on invalid post' do
      req_payload = {
        post: {
          content: 'content',
          published: false,
          user_id: user.id
        }
      }

      # POST HTTP
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /posts/{id}' do
    let!(:article) { create(:post) }

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          published: true
        }
      }

      # PUT HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(article.id)
      expect(response).to have_http_status(:ok)
    end

    it 'should return error message on invalid post' do
      req_payload = {
        post: {
          title: nil,
          content: nil,
          published: false
        }
      }

      # PUT HTTP
      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
