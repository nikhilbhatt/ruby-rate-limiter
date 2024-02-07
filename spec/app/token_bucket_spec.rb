# frozen_string_literal: true

require 'spec_helper'

describe 'App' do
  include Rack::Test::Methods

  def app
    App
  end

  describe 'GET /limited' do
    context 'when rate limit is not exceeded' do
      it 'returns a limited message' do
        allow(RateLimiter::TokenBucket).to receive(:valid_request?).and_return(true)
        get '/limited_token_bucket'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Limited, dont over use me! Implemented using token bucket algorithm')
      end
    end

    context 'when rate limit is exceeded' do
      it 'returns a 429 status and an error message' do
        allow(RateLimiter::TokenBucket).to receive(:valid_request?).and_return(false)
        get '/limited_token_bucket'
        expect(last_response.status).to eq(429)
        expect(last_response.body).to include('Too Many Request! Try Again later - Token Bucket')
      end
    end

    context 'When actual request is sent' do
      it 'Returns 429 if number of requests are greater than 10 within a minute' do
        20.times do |request_counter|
          get '/limited_token_bucket'

          if request_counter >= 10
            expect(last_response.status).to eq(429)
            expect(last_response.body).to include('Too Many Request! Try Again later - Token Bucket')
          else
            expect(last_response).to be_ok
            expect(last_response.body).to include('Limited, dont over use me! Implemented using token bucket algorithm')
          end
        end
      end
    end
  end
end
