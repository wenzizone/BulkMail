#! /usr/bin/env ruby
#-- encoding: utf-8 --

#require 'rubygems'
require "base64"
require 'net/smtp'
require 'gearman-ruby/lib/gearman'


# 创建邮件内容
def create_email_content(subject, emailaddress, enc_fcontent)
	s = Base64.encode64(subject)
	ss = s.gsub(/\n/, '')
	mail_subject = 'Subject: =?utf-8?B?' + ss + "?=\n"

	recp_user_array = emailaddress.split('@')
	mail_recp_to = 'To: '+recp_user_array[0] + ' <' + emailaddress + '>'
	#mail_from = 'From: 无忧运维 <noreply@noreply.5uops.com>'
	mail_from = 'From: wenzizone <wenzizone@126.com>'

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

# 群发邮件
def groupemail(emailcontent, emailaddress)
	begin
		Net::SMTP.start('smtp.126.com',25,'smtp.126.com','wenzizone@126.com','830714810308',:plain) do |smtp|
			smtp.sendmail(emailcontent, 'wenzizone@126.com', emailaddress)
		end
		return true
	rescue Exception => e
		p e
		return false
	end
	
end

# 判断是否传进了文件参数
if ARGV.length < 2 then
	puts "请输入要发送邮件内容的文件全路径！"
	puts "Usage : " + __FILE__ + " /path/to/email.html 发送邮件的主题"
	exit 1
end

emails = ['48973947@qq.com', 'jpuyy.com@gmail.com', '841307187@qq.com', 'jpuyy@163.com', 'yangyang1989@yahoo.cn', 'lhz8138@sina.com', 'wenzizone@gmail.com', 'c35200@gmail.com']

emailFile = ARGV[0]
subject = ARGV[1]

#p subject
#p s
#=begin
s = Base64.encode64(subject)
p s.gsub(/\n/,'')

#=end
filecontent = File.read(emailFile)
enc_fcontent = Base64.encode64(filecontent)

#Subject: ruby sendmail test
#From: 无忧运维 <noreply@noreply.5uops.com>
#To: jason <c35200@gmail.com>
=begin
emails.each { |email|
	emailmessage = create_email_content(subject, email, enc_fcontent)	
	send_rs = groupemail(emailmessage, email)
	if send_rs == false then
		puts "#{email} 发送失败"
	end
#puts email

}
=end


# 通过gearman分布式使用worker放松邮件
client = Gearman::Client.new('localhost')
taskset = Gearman::TaskSet.new(client)

emails.each { |email|
	emailmessage = create_email_content(subject, email, enc_fcontent)
	emaildata = emailmessage+','+email

	
	#task = Gearman::Task.new('sendmail', emaildata, { :background => true })
	task = Gearman::Task.new('sendmail', emaildata)
	task.on_data {|d| puts d}
	task.on_complete { |d|
		puts d
	}
	#p "[client] Sending task: #{task.inspect}, to the sendmail worker"
	taskset.add_task(task)
	taskset.wait(100)

}

#puts enc_fcontent;



