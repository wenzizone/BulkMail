module Api
    class GetImport
        def self.getimportjobs(uid)
            # 从tb_import_jobs表中把数据取出来
            q = "SELECT * FROM `tb_import_jobs` WHERE `user_id`='#{uid}'"
            res = {}
            DB.query(q).each { |row|
                p row
                qq = "SELECT originname FROM `tb_file` WHERE `id`='#{row[1]}'"
                t = DB.query(qq).fetch_row()
                tmp = {row[0] => {:file => "#{t[0]}", :starttime => "#{row[3]}", :finishtime => "#{row[4]}", :status => "#{row[2]}"}}
                res.update(tmp) 
                p res
            }
            return res
        end
    end

    class GetSend

    end
end
