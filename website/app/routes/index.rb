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

post '/import' do
    p params[:file]
    p params[:clientType]
end

post '/upload' do
    if File.exist?(params[:SolmetraUploader][:tempfile]) and File.size?(params[:SolmetraUploader][:tempfile])
        filename = params[:Filename]
        tmpfile = params[:SolmetraUploader][:tempfile]
        rootdir = File.dirname(__FILE__)
        target = "uploads/#{filename}"
        FileUtils.cp(tmpfile, target)
=begin   
        File.open(target, 'wb') { |f|
            f.write tmpfile.read
        }
=end
        p "OK:#{filename}"
    else
        p "ERROR:UPLOAD_ERR_INI_SIZE"
    end
end

