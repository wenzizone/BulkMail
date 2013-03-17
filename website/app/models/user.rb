#module User
=begin
        @@db_server = settings.config['dbconfig']['server']
        @@db_port = settings.config['dbconfig']['port']
        @@db_user = settings.config['dbconfig']['db_user']
        @@db_pass = settings.config['dbconfig']['db_pass']
        @@db_name = settings.config['dbconfig']['db_name']
        @@dbh = Mysql::new(@@db_server, @@db_user, @@db_pass, @@db_name, @@db_port)
=end
    class UserInfo
        def get_user_pass(username)
            p settings.config
            #q = "select * from tb_user where username=\"#{username}\""
            #res = @@dbh.query(q)
            #p res
        end
    end
#end
