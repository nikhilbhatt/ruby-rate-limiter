# frozen_string_literal: true

require 'spec_helper'

describe 'Sliding Window Log Algorithm' do
  include Rack::Test::Methods

  def app
    App
  end

  context 'when rate limit is not exceeded' do
    it 'returns a limited message' do
      allow(RateLimiter::SlidingWindowLog).to receive(:valid_request?).and_return(true)
      get '/limited_sliding_window'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Limited, End Point for sliding window log algorithm')
    end
  end

  context 'when rate limit is exceeded' do
    it 'returns a 429 status and an error message' do
      allow(RateLimiter::SlidingWindowLog).to receive(:valid_request?).and_return(false)
      get '/limited_sliding_window'
      expect(last_response.status).to eq(429)
      expect(last_response.body).to include('Too Many Request! Try Again later - Sliding Window Log')
    end
  end

  context 'When actual request is sent' do
    it 'Returns 429 if number of requests are greater than 10 within a minute' do
      20.times do |request_counter|
        get '/limited_sliding_window'

        if request_counter >= 10
          expect(last_response.status).to eq(429)
          expect(last_response.body).to include('Too Many Request! Try Again later - Sliding Window Log')
        else
          expect(last_response).to be_ok
          expect(last_response.body).to include('Limited, End Point for sliding window log algorithm')
        end
      end
    end
  end
end
