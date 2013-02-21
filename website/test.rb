require 'rubygems'
require 'sinatra'

get '/hi/:name' do |n|
	"hello #{n}"
end

get '/' do
    "hello branch"
end
