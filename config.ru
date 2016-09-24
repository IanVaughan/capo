$:.unshift File.expand_path("../", __FILE__)
require 'dotenv'
Dotenv.load
require 'capo'
require './app/server'

require 'sidekiq/web'
run Rack::URLMap.new(
  '/' => Server,
  '/sidekiq' => Sidekiq::Web
)
