#use Rack::Session::Pool

get '/hello' do
    p 'hello world' 
    "test =" <<settings.config.inspect
end

get '/login' do
    slim :login, :layout => false
end

post '/login' do
    username = params[:username]
    passwd = params[:passwd]
    userinfo = User::UserInfo.get_user_info(username)
    if Digest::MD5.hexdigest(passwd) == userinfo[2]
        session[:login] = true
        session[:user_id] = userinfo[0]
        session[:user] = username
        redirect '/'
    else
        redirect '/login'
    end
    #{}"userinfo ="<<userinfo.inspect 
end

get '/logout' do
    slim :logout, :layout => false
end

get '/' do
    if session['login']
    #session[:secret] = 'Buik_mail_2013'
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
    "My session =" << session[:value].inspect
end

post '/import' do
    p params
    p session
    "strings = " << params.inspect
    slim :import, :locals => {:data => params.inspect}
end

post '/upload' do
    content_type :json
    p params
    output = {}
    filename = params[:Filename]
    md5s = Digest::MD5.hexdigest(filename)
    ext = filename.split('.')[1]
    tmpfile = params[:email_file][:tempfile]
    rootdir = File.dirname(__FILE__)
    target = "uploads/#{md5s}.#{ext}"
    #FileUtils.cp(tmpfile, target)
    File.open(target, 'wb') { |f|
        f.write tmpfile.read
    }
    output = {'filename' => "#{target}", "md5s" => "#{md5s}"}

    p output.to_json
    output.to_json
end

get '/test' do
    slim :test
end

