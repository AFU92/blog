# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    auth_token { 'token_123' }
  end
end
