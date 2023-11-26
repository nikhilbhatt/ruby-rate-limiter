# frozen_string_literal: true

require 'sinatra/base'
require_relative './rate_limiter/token_bucket'

# Start
class App < Sinatra::Base
  before do
    halt 429, 'Too Many Request! Try Again later' unless RateLimiter::TokenBucket.valid_request?(request.ip)
  end

  get '/' do
    'Basic Sinatra application will be used for various rate limiting algorithms'
  end

  get '/unlimited' do
    "Unlimited! Let's Go!"
  end

  get '/limited' do
    "Limited, don't over use me! #{@size}"
  end
end
