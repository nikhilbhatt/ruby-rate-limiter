# frozen_string_literal: true

require 'spec_helper'

describe 'Fixed Window Counter Algorithm' do
  include Rack::Test::Methods

  def app
    App
  end

  context 'when rate limit is not exceeded' do
    it 'returns a limited message' do
      allow(RateLimiter::FixedWindowCounter).to receive(:valid_request?).and_return(true)
      get '/limited_window_counter'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Limited, End Point for fixed window counter algorithm')
    end
  end

  context 'when rate limit is exceeded' do
    it 'returns a 429 status and an error message' do
      allow(RateLimiter::FixedWindowCounter).to receive(:valid_request?).and_return(false)
      get '/limited_window_counter'
      expect(last_response.status).to eq(429)
      expect(last_response.body).to include('Too Many Request! Try Again later - Fixed Window Counter')
    end
  end

  context 'When actual request is sent' do
    it 'Returns 429 if number of requests are greater than 60 within a minute' do
      70.times do |request_counter|
        get '/limited_window_counter'

        if request_counter > 60
          expect(last_response.status).to eq(429)
          expect(last_response.body).to include('Too Many Request! Try Again later - Fixed Window Counter')
        else
          expect(last_response).to be_ok
          expect(last_response.body).to include('Limited, End Point for fixed window counter algorithm')
        end
      end
    end
  end
end
