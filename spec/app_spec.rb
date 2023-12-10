# frozen_string_literal: true

require 'spec_helper'

describe 'App' do
  include Rack::Test::Methods

  def app
    App
  end

  describe 'GET /' do
    it 'returns a welcome message' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Basic Sinatra application will be used for various rate limiting algorithms')
    end
  end

  describe 'GET /unlimited' do
    it 'returns an unlimited message' do
      get '/unlimited'
      expect(last_response).to be_ok
      expect(last_response.body).to include("Unlimited! Let's Go!")
    end
  end

  describe 'GET /limited' do
    context 'when rate limit is not exceeded' do
      it 'returns a limited message' do
        allow(RateLimiter::TokenBucket).to receive(:valid_request?).and_return(true)
        get '/limited'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Limited, dont over use me!')
      end
    end

    context 'when rate limit is exceeded' do
      it 'returns a 429 status and an error message' do
        allow(RateLimiter::TokenBucket).to receive(:valid_request?).and_return(false)
        get '/limited'
        expect(last_response.status).to eq(429)
        expect(last_response.body).to include('Too Many Request! Try Again later')
      end
    end
  end
end