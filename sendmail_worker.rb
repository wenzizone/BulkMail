#! /usr/bin/env ruby
#-- encoding: utf-8 --

require 'net/smtp'
require 'gearman-ruby/lib/gearman'

def groupemail(emailcontent, emailaddress)
	begin
		Net::SMTP.start('smtp.126.com',25,'smtp.126.com','wenzizone@126.com','830714810308',:plain) do |smtp|
			smtp.sendmail(emailcontent, 'wenzizone@126.com', emailaddress)
		end
		return "mail send to #{emailaddress} success"
	rescue Exception => e
		p e
		return "mail send to #{emailaddress} failed"
	end
	
end


worker = Gearman::Worker.new('localhost')
worker.reconnect_sec = 2

worker.add_ability('sendmail') do |data, job|
	data_array = data.split(/,/)
	p data_array[1]
	send_status = groupemail(data_array[0], data_array[1])
	#job.send_data(data_array[1])
	job.report_status(data_array[1], 5)
	#send_status
	true
	#p data_array[1]
end

loop do
	worker.work
end

