#! /usr/bin/env ruby

require "base64";
require 'net/smtp';

# 判断是否传进了文件参数
if ARGV.length < 1 then
	puts "请输入要发送邮件内容的文件全路径！";
	puts "Usage : " + __FILE__ + " /path/to/email.html";
	exit 1;
end

emails = ['jpuyy.com@gmail.com', '841307187@qq.com', 'jpuyy@163.com
', 'yangyang1989@yahoo.cn', 'lhz8138@sina.com']

emailFile = ARGV[0];

filecontent = File.read(emailFile);
enc_fcontent = Base64.encode64(filecontent);

Subject: ruby sendmail test
From: 无忧运维 <noreply@noreply.5uops.com>
To: jason <c35200@gmail.com>

fixheader = <<MESSAGECONTENT
MIME-Version: 1.0
Content-type: text/html
Content-Transfer-Encoding:base64
MESSAGECONTENT



Net::SMTP.start('smtp.126.com',
				25,
				'smtp.126.com',
				'wenzizone@126.com',
				'830714810308',
				:plain) do |smtp|
	smtp.sendmail(message+enc_fcontent, 'wenzizone@126.com', 'wenzizone@gmail.com');
end
puts enc_fcontent;


def groupemail() 

end
