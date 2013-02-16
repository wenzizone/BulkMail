#! /usr/bin/env ruby
#-- encoding: utf-8 --

#require 'rubygems'
require 'net/smtp'
require 'gearman-ruby/lib/gearman'
require 'json'

def groupemail(emailcontent, emailaddress)
	begin
		Net::SMTP.start('smtp.126.com',25,'smtp.126.com','wenzizone@126.com','830714810308',:plain) do |smtp|
			smtp.sendmail(emailcontent, 'wenzizone@126.com', emailaddress)
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
