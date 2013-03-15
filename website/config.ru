#require 'sinatra'
require 'rubygems'
require 'bundler/setup'

require './app'
sessioned = Rack::Session::Pool.new(BulkMail.new, :secret => 'BulkMail', :expire_after => 100)
run sessioned
