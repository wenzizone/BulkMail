get '/hello' do
    p 'hello world' 
end

get '/login' do
    p session
    slim :login, :layout => false
end

post '/login' do
    p session
    username = params[:username]
    passwd = params[:passwd]
    if username == 'admin@test.com' and passwd == '12345678'
        session['sinatra.session'] = true
        session[:name] = username
        redirect '/'
    else
        redirect '/login'
    end
end


get '/logout' do
    slim :logout, :layout => false
end

get '/' do
    p session
    if session['sinatra.session']
        slim :index
    else
        redirect '/login'
    end
    
end

get '/send' do
    slim :send
end

get '/quary' do
    slim :quary
end

get '/mysession' do
    "My session =" << session.inspect
end

get '/test/:id' do
    session[:test] = params[:id]
end

post '/import' do
    p params[:clientType]
    "My session =" << session.inspect
end

# 上传文件
post '/upload' do
    if File.exist?(params[:SolmetraUploader][:tempfile]) and File.size?(params[:SolmetraUploader][:tempfile])
        filename = params[:Filename]
        tmpfile = params[:SolmetraUploader][:tempfile]
        rootdir = File.dirname(__FILE__)
        target = "uploads/#{filename}"
        FileUtils.cp(tmpfile, target)
        session['filename'] = "#{target}"
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

