# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'post endpoint', type: :request do
  describe 'GET /post is empty' do
    before { get '/post' }

    it 'should return OK' do
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end

  describe 'With data in the database' do
    # describe "GET /post is successfully"
    before { get '/post' }

    let(:posts) { create_list(:post, 10, published: true) }

    it 'should return all the published posts' do
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end

    describe 'GET /post/{id}' do
      let(:posts) { create(:post) }

      it 'should return a posts' do
        get "/post/#{post.id}"
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(payload['id']).to eq(post.id)
        expect(response).to have_http_status(200)
      end
    end
  end
end
