#! /usr/bin/env ruby
#-- encoding: utf-8 --

require 'rubygems'
require 'json'
require 'net/smtp'
require 'gearman-ruby/lib/gearman'


def groupemail(emailcontent, emailaddress)
	begin
		Net::SMTP.start('smtp.126.com',25,'smtp.126.com','mail5uops@126.com','5uops@2013',:plain) do |smtp|
			smtp.sendmail(emailcontent, 'mail5uops@126.com', emailaddress)
		end
		return true
	rescue Exception => e
		return e
	end
	
end


worker = Gearman::Worker.new('localhost')
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

loop do
	worker.work
end

