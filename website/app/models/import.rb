module Import
    class Files
        def self.insert_tb_file(data)
            q = "INSERT INTO `tb_file` (`filename`, `originname`, `user_id`, `file_hash`) VALUES ( '#{data['filename']}', '#{data['originname']}', '#{data['user_id']}', '#{data['file_hash']}');"
            DB.query(q)
            insert_id = DB.insert_id
        end
        def self.insert_tb_import_jobs(data)
            q = "INSERT INTO `tb_import_jobs` (`file_id`, `status`, `starttime`, `user_id`) VALUES ( '#{data['file_id']}', 'pending', NOW(), '#{data['user_id']}');"
            DB.query(q)
            insert_id = DB.insert_id
        end
        def self.update_tb_import_jobs(data)
            q = "UPDATE `tb_import_jobs` SET status='importing....' WHERE id='#{data['import_id']}'"
            DB.query(q)
        end
    end
end
