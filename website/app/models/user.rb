module User
    class UserInfo
        def self.get_user_info(username)
            user = {}
            q = "select * from tb_user where username=\"#{username}\""
            res = DB.query(q).fetch_row
        end
    end
end
