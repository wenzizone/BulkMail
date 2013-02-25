require 'sinatra'

get '/hello' do
	p 'hello world'	
end


get '/' do
    slim :index
end

get '/:send' do
    @send = params[:send]
    slim :send
end