# frozen_string_literal: true

# app
class App < Sinatra::Base
  before '/limited_token_bucket' do
    unless RateLimiter::TokenBucket.valid_request?(request.ip)
      halt 429, 'Too Many Request! Try Again later - Token Bucket'
    end
  end

  before '/limited_window_counter' do
    unless RateLimiter::FixedWindowCounter.valid_request?
      halt 429, 'Too Many Request! Try Again later - Fixed Window Counter'
    end
  end

  before '/limited_sliding_window' do
    unless RateLimiter::SlidingWindowLog.valid_request?(request.ip)
      halt 429, 'Too Many Request! Try Again later - Sliding Window Log'
    end
  end

  get '/' do
    'Basic Sinatra application will be used for various rate limiting algorithms'
  end

  get '/unlimited' do
    "Unlimited! Let's Go!"
  end

  get '/limited_token_bucket' do
    'Limited, dont over use me! Implemented using token bucket algorithm'
  end

  get '/limited_window_counter' do
    'Limited, End Point for fixed window counter algorithm'
  end

  get '/limited_sliding_window' do
    'Limited, End Point for sliding window log algorithm'
  end
end
