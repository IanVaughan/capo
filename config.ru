$:.unshift File.expand_path("../", __FILE__)
require 'sinatra'
require 'capo'

run Server
