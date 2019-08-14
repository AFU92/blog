# frozen_string_literal: true

require 'rails_helper'
#require 'byebug'

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
      #byebug
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end

    describe 'GET /posts/{id}' do
      let!(:post) { create(:post) }

      it 'should return a posts' do
        get "/posts/#{post.id}"
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(payload['id']).to eq(post.id)
        expect(response).to have_http_status(200)
      end
    end
  end
end
