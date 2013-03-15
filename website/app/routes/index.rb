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
    p params
    "strings = " << params.inspect
end

post '/upload' do
    content_type :json
    p params
    output = {}
    if File.exist?(params[:email_file][:tempfile]) and File.size?(params[:email_file][:tempfile])
        filename = params[:Filename]
        tmpfile = params[:email_file][:tempfile]
        rootdir = File.dirname(__FILE__)
        target = "uploads/#{filename}"
        #FileUtils.cp(tmpfile, target)
        File.open(target, 'wb') { |f|
            f.write tmpfile.read
        }
        output = {'OK' => "#{filename}"}
    else
        p "ERROR:UPLOAD_ERR_INI_SIZE"
    end
    p output.to_json
    output.to_json
end

get '/test' do
    slim :test
end

