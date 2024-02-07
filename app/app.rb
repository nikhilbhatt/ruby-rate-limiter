# frozen_string_literal: true

# app
class App < Sinatra::Base
  before '/limited_token_bucket' do
    halt 429, 'Too Many Request! Try Again later - Token Bucket' unless RateLimiter::TokenBucket.valid_request?(request.ip)
  end

  before '/limited_window_counter' do
    halt 429, 'Too Many Request! Try Again later - Fixed Window Counter' unless RateLimiter::FixedWindowCounter.valid_request?
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
end
