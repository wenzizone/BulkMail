require 'sinatra'
use Rack::Session::Pool, :expire_after => 259200

get '/hello' do
    p 'hello world' 
end

get '/login' do
    slim :login, :layout => false
end

get '/logout' do
    slim :logout, :layout => false
end

get '/' do
    session[:secret] = 'Buik_mail_2013'
    slim :index
end

get '/send' do
    slim :send
end

get '/quary' do
    slim :quary
end

get '/mysession' do
    "My session =" << session[:value].inspect
end

