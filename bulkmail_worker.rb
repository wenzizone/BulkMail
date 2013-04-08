#! /usr/bin/env ruby
#-- encoding: utf-8 --
#encoding=UTF-8
require 'rubygems'
require 'json'
require 'net/smtp'
require 'yaml'
require 'gearman'
require 'mysql'

config = YAML.load_file(Dir.pwd+"/website/config/config.yml")
basedir = File.expand_path(File.dirname(__FILE__))

def db_conn(dbinfo)
    begin
        conn = Mysql::new(dbinfo['db_server'], dbinfo['db_user'], dbinfo['db_pass'], dbinfo['db_name'], dbinfo['db_port'])
        conn.query("SET NAMES UTF8")
        return conn
    rescue Exception => e
        p e.message
    end
end

def groupemail(data)
    p data
    if data[:ownserver] == 'y'
        begin
            Net::SMTP.start(data[:mailserver], 25, data[:mailserver], data[:smtpuser], data[:smtppass], :plain) do |smtp|
                smtp.sendmail(data['emailcontent'], data['s_email'], data['r_email'])
            end
        rescue Exception => e
            return e.message
        end
    else
        begin
            Net::SMTP.start('mail1.onjai.net',25,'mail1.onjai.net','noreply','use4noreply',:plain) do |smtp|
                smtp.sendmail(data['emailcontent'], data['s_email'], data['r_email'])
            end
            return true
        rescue Exception => e
            return e.message
        end
    end
end

def import(dbh, data)
    # 创建邮件地址表
    q = "CREATE  TABLE IF NOT EXISTS `BulkMail`.`tb_#{data['file_hash']}` (`id` INT NOT NULL AUTO_INCREMENT,  `name` VARCHAR(45) NULL ,  `email` VARCHAR(45) NULL ,  `active` CHAR(1) NULL ,  PRIMARY KEY (`id`) )ENGINE = InnoDB,DEFAULT CHARACTER SET = utf8,COLLATE = utf8_general_ci"
    dbh.query(q)

    # 更新tb_tablename表
    q = "INSERT INTO `tb_tablename` (`tablename`, `user_id`) VALUES ( '#{data['file_hash']}','#{data['user_id']}' );"
    dbh.query(q)
    p data['basedir']
    # 开始导入邮件地址
    p File.join(data['basedir'],'website',data['filename'])
    begin
        fh = File.open(File.join(data['basedir'],'website',data['filename']), 'r')
        begin
            while fh.readline do
                unless /^\(\d+/=~$_
                    next
                else
                    $_ = $_.gsub(/\s+/, '')
                    $_ = $_.gsub(/'/, '')
                    email = $_.split(',')[1]
                    name = email.split('@')[0]
                    q = "INSERT INTO `tb_#{data['file_hash']}` (`name`, `email`) VALUES ( '#{name}','#{email}');"
                    p q.encoding
                    dbh.query(q)
                end
            end
        rescue Exception => e
            p e.message
            return true
        end
    rescue Exception => e
        p e.message
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
    groupemail(data_decode)
    # 返回发送状态
    
end

worker.add_ability('jobs_send') do |data,job|

end

worker.add_ability('import') do |data, job|
    dbh = db_conn(config['development']['dbconfig'])
    data_decode = JSON.parse(data)
    data_decode['basedir'] = basedir
    q = "UPDATE `tb_import_jobs` SET status='importing....' WHERE id='#{data_decode['import_id']}'"
    dbh.query(q)
=begin
    begin
        File.open('/tmp/tmpfile.txt', 'wb') { |f|
            f.write data_decode
        }
    rescue Exception => e
        p e.message
    end
    sleep 300
=end
    if import(dbh, data_decode)
        q = "UPDATE `tb_import_jobs` SET `status`='finished', `finishtime`=NOW() WHERE `id`='#{data_decode['import_id']}'"
        dbh.query(q)
    end

    #job.send_data(data_decode)
    #puts data_decode
end

loop do
    worker.work
end

