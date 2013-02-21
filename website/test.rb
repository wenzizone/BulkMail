require 'rubygems'
require 'sinatra'
require 'slim'

=begin
get '/hi/:name' do |n|
	"hello #{n}"
end
=end

get '/' do
    slim :index
end
