# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'sinatra/base'
require './app/app'
require './app/rate_limiter/token_bucket'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)
