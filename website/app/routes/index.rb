require 'sinatra'

get '/hello' do
	p 'hello world'	
end

get '/login' do
    slim :login, :layout => false
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
