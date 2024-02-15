# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'sinatra/base'
require './app/app'
require './app/rate_limiter/token_bucket'
require './app/rate_limiter/fixed_window_counter'
require './app/rate_limiter/sliding_window_log'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)
