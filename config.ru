$:.unshift File.expand_path("../", __FILE__)
require 'dotenv'
Dotenv.load
require 'sinatra'
require 'capo'

run Server
