# app.rb
require 'sinatra'

get '/' do
  'Basic Sinatra application will be used for various rate limiting algorithms'
end

get '/unlimited' do
  "Unlimited! Let's Go!"
end

get '/limited' do
  "Limited, don't over use me!"
end
