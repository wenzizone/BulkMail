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
    #"userinfo ="<<userinfo.inspect 
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
    formupload = JSON.parse(params[:hidFileID])
    fileinfo = params[:clientType]
    p formupload
    # 更新tb_file表
    data = {'filename' => formupload['filename'],
        'originname' => formupload['originname'],
        'user_id' => session['user_id'],
        'file_hash' => formupload['md5s'],
        'fileinfo' => fileinfo}
    file_id = Import::Files.insert_tb_file(data)
    # 更新导入任务表
    data['file_id'] = file_id
    import_id = Import::Files.insert_tb_import_jobs(data)
    data['import_id'] = import_id
    # 发送导入任务到gearman
    p settings.config[ENV["RACK_ENV"]]['gearmanconfig']['server']
    if import_id
        client = Gearman::Client.new(settings.config[ENV["RACK_ENV"]]['gearmanconfig']['server'])
        taskset = Gearman::TaskSet.new(client)
        task = Gearman::Task.new('import', data.to_json.force_encoding('ASCII-8BIT'), {:background => true})
        taskset.add_task(task)
    end

    #p res
    originname = formupload['originname']
    p originname
    slim :import, :locals => {:originname => originname}
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
    output = {'filename' => "#{target}", "md5s" => "#{md5s}", "originname" => "#{filename}"}

    p output.to_json
    output.to_json
end

get '/test' do
    slim :test
end

get '/user_profile' do
    slim :user_profile, :layout => :'layout/userlayout'
end

get '/jobs_view' do
    slim :jobs_view, :layout => :'layout/userlayout',:locals => {:uid => session[:user_id]}
end

