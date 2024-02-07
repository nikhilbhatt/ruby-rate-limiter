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
      expect(last_response.body).to include(
        'Basic Sinatra application will be used for various rate limiting algorithms'
      )
    end
  end

  describe 'GET /unlimited' do
    it 'returns an unlimited message' do
      get '/unlimited'
      expect(last_response).to be_ok
      expect(last_response.body).to include("Unlimited! Let's Go!")
    end
  end
end
