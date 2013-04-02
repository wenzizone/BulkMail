module Api
    class GetImport
        def self.getimportjobs(uid)
            # 从tb_import_jobs表中把数据取出来
            q = "SELECT * FROM `tb_import_jobs` WHERE `user_id`='#{uid}'"
            res = []
            DB.query(q).each { |row|
                qq = "SELECT originname FROM `tb_file` WHERE `id`='#{row[1]}'"
                t = DB.query(qq).fetch_row()
                tmp = {:file => "#{t[0]}", :starttime => "#{row[3]}", :finishtime => "#{row[4]}", :status => "#{row[2]}"}
                res.push(tmp) 
            }
            return res
        end #end self.getimportjobs
    end #end class GetImport

    class GetSend
        def self.gettable(uid)
            #get table list
            q = "SELECT originname, info, tablename FROM tb_file AS a, tb_import_jobs AS b, tb_tablename AS c WHERE a.user_id = b.user_id = c.user_id AND b.user_id = '#{uid}' AND b.status = 'finished'"
            res = []
            DB.query(q).each { |row|
                if row[1]
                    tmp = {:info => row[1], :tablename => row[2]}
                else
                    tmp = {:info => row[0], :tablename=> row[2]}
                end
                res.push(tmp)
            }
            return res
        end #end self.gettable
    end #end GetSend

    class SendJobs
        def self.sendmail(data)
            
        end # end self.sendmail
    end # end SendJobs

end # module Api
