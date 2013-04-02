#! /usr/bin/env ruby
#-- encoding: utf-8 --

require 'rubygems'
require 'json'
require "base64"
require 'net/smtp'
require 'yaml'
require 'gearman'

config = YAML.load_file(Dir.pwd+"/website/config/config.yml")

data = ARGV[0]

# 创建数据库连接
def db_conn(dbinfo)
    begin
        conn = Mysql::new(dbinfo['db_server'], dbinfo['db_user'], dbinfo['db_pass'], dbinfo['db_name'], dbinfo['db_port'])
        conn.query("SET NAMES UTF8")
        return conn
    rescue Exception => e
        p e.message
    end
end

#p config['gearmanconfig']['server']
p config['development']['gearmanconfig']['server']


# main
begin
    client = Gearman::Client.new(config['development']['gearmanconfig']['server'])
    taskset = Gearman::TaskSet.new(client)

    task = Gearman::Task.new('import', "{'info' => 20}".to_json)
    taskset.add_task(task)
rescue Exception => e
    p e.message
end

filecontent = File.read(emailFile)
enc_fcontent = Base64.encode64(filecontent)

# 

emails.each { |email|
    emailmessage = create_email_content(subject, email, enc_fcontent)
    emaildata = {"email" => "#{email}", "emailmessage" => "#{emailmessage}"} #emailmessage+','+email

    #task = Gearman::Task.new('sendmail', emaildata, { :background => true })
    task = Gearman::Task.new('sendmail', emaildata.to_json)
    #task.on_data {|d| puts d}
    task.on_complete { |d|
        puts d
    }
    #p "[client] Sending task: #{task.inspect}, to the sendmail worker"
    taskset.add_task(task)
    taskset.wait(100)

}

=begin
# åˆ›å»ºé‚®ä»¶å†…å®¹
def create_email_content(subject, emailaddress, enc_fcontent)
    s = Base64.encode64(subject)
    ss = s.gsub(/\n/, '')
    mail_subject = 'Subject: =?utf-8?B?' + ss + "?=\n"

    recp_user_array = emailaddress.split('@')
    mail_recp_to = 'To: '+recp_user_array[0] + ' <' + emailaddress + '>'
    mail_from = 'From: æ— å¿§è¿ç»´ <noreply@onjai.net>'
    #mail_from = 'From: wenzizone <wenzizone@126.com>'

    message = <<EOF
#{mail_from}
#{mail_recp_to}
MIME-Version: 1.0
Content-type: text/html;charset=UTF-8
Content-Transfer-Encoding:base64
#{mail_subject}


#{enc_fcontent}
.
EOF

#p mail_subject
    return message
end

# ç¾¤å‘é‚®ä»¶
def groupemail(emailcontent, emailaddress)
    begin
        Net::SMTP.start('smtp.126.com',25,'smtp.126.com','mail5uops@126.com','5uops@2013',:plain) do |smtp|
            smtp.sendmail(emailcontent, 'mail5uops@126.com', emailaddress)
        end
        return true
    rescue Exception => e
        p e
        return false
    end
    
end



emails = ['48973947@qq.com', 'jpuyy.com@gmail.com', '841307187@qq.com', 'jpuyy@163.com', 'yangyang1989@yahoo.cn', 'lhz8138@sina.com', 'wenzizone@gmail.com', 'c35200@gmail.com']


=end
