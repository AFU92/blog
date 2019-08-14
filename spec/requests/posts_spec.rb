# frozen_string_literal: true

require 'rails_helper'
# require 'byebug'

RSpec.describe 'posts endpoint', type: :request do
  describe 'GET /posts is empty' do
    before { get '/posts' }

    it 'should return OK' do
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end

  describe 'With data in the database' do
    # describe "GET /posts is successfully"
    let!(:posts) { create_list(:post, 10, published: true) }

    before { get '/posts' }

    it 'should return all the published posts' do
      # byebug
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end

    describe 'GET /posts/{id}' do
      let!(:post) { create(:post) }

      it 'should return a posts' do
        get "/posts/#{post.id}"
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload['id']).to eq(post.id)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /posts' do
    let!(:user) { create(:user) }

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          publised: false,
          user_id: user.id
        }
      }

      # POST Http
      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to_not be_empty
      expect(response).to have_http_status(:created)
    end
  end


  describe 'PUT /posts' do
    let!(:post_db) { create(:post) }

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          publised: true 
          
        }
      }

      # PUT Http
      put "/posts/#{post_db}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post_db.id)
      expect(response).to have_http_status(:ok)
    end
  end
end
