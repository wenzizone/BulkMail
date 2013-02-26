require 'sinatra'

get '/hello' do
	p 'hello world'	
end


get '/' do
    slim :index
end

get '/send' do
    slim :send
end

get '/quary' do
    slim :quary
end
