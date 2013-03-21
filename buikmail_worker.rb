#! /usr/bin/env ruby
#-- encoding: utf-8 --

require 'rubygems'
require 'json'
require 'net/smtp'
require 'yaml'
require 'gearman'
require 'mysql'

config = YAML.load_file(Dir.pwd+"/website/config/config.yml")

def db_conn(dbinfo)
	conn = Mysql::new(dbinfo['db_server'], dbinfo['db_user'], dbinfo['db_pass'], dbinfo['db_name'], dbinfo['db_port'])
	conn.query("SET NAMES UTF8")
	conn
end

def groupemail(emailcontent, emailaddress)
	begin
		Net::SMTP.start('mail1.onjai.net',25,'mail1.onjai.net','noreply','use4noreply',:plain) do |smtp|
			smtp.sendmail(emailcontent, 'noreply@onjai.net', emailaddress)
		end
		return true
	rescue Exception => e
		return e
	end
	
end

p config['development']

worker = Gearman::Worker.new(config['development']['gearmanconfig']['server'])
worker.reconnect_sec = 2

worker.add_ability('sendmail') do |data, job|
	data_decode = JSON.parse(data)
	#p data_decode['email']
	#data_array = data.split(/,/)
	#p data_array[1]
	#send_status = groupemail(data_array[0], data_array[1])
	send_status = groupemail(data_decode['emailmessage'], data_decode['email'])
	# 返回发送状态
	send_status
end

worker.add_ability('import') do |data, job|
	dbh = de_conn(config['development']['dbconfig'])
	data_decode = JSON.parse(data)
	q = "UPDATE `tb_import_jobs` SET status=\"importing....\" WHERE id=\"#{data_decode['import_id']}\""
	dbh.query(q)
	File.open('/tmp/tmpfile.txt', 'wb') { |f|
		f.write data_decode
	}
	sleep 300
	
	q = "UPDATE `tb_import_jobs` SET `status`=\"importing....\", `finishtime`=NOW() WHERE `id`=\"#{data_decode['import_id']}\""
	dbh.query(q)
	#job.send_data(data_decode)
	#puts data_decode
end

loop do
	worker.work
end

