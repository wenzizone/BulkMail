#! /usr/bin/env ruby

require "base64"
require 'net/smtp'

def create_email_content(subject, emailaddress, enc_fcontent)
	mail_subject = 'Subject: ' + subject
	recp_user_array = emailaddress.split('@')
	mail_recp_to = 'To: '+recp_user_array[0] + ' <' + emailaddress + '>'
	#mail_from = 'From: 无忧运维 <noreply@noreply.5uops.com>'
	mail_from = 'From: wenzizone <wenzizone@126.com>'

	message = <<EOF
MIME-Version: 1.0
Content-type: text/html
Content-Transfer-Encoding:base64
#{mail_subject}
#{mail_recp_to}
#{mail_from}
#{enc_fcontent}
EOF
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
		return false
	end
	
end

# 判断是否传进了文件参数
if ARGV.length < 2 then
	puts "请输入要发送邮件内容的文件全路径！"
	puts "Usage : " + __FILE__ + " /path/to/email.html 发送邮件的主题"
	exit 1
end

emails = ['jpuyy.com@gmail.com', '841307187@qq.com', 'jpuyy@163.com
', 'yangyang1989@yahoo.cn', 'lhz8138@sina.com', '48973947@qq.com']

emailFile = ARGV[0]
subject = ARGV[1]

filecontent = File.read(emailFile)
enc_fcontent = Base64.encode64(filecontent)

#Subject: ruby sendmail test
#From: 无忧运维 <noreply@noreply.5uops.com>
#To: jason <c35200@gmail.com>

emails.each { |email|
	emailmessage = create_email_content(subject, email, enc_fcontent)
	send_rs = groupemail(emailmessage, email)
	if send_rs == false then
		puts "#{email} 发送失败"
	end
#puts email
	
}
#puts enc_fcontent;

# 创建邮件内容

