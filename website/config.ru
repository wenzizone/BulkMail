#require 'sinatra'
require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'connection_pool'
require 'mysql'

require './app'

#ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined?ROOT_DIR
#CONFIG = YAML.load_file(ROOT_DIR+"/config.yml")

class DB
    @@db_server = CONFIG[ENV["RACK_ENV"]]['dbconfig']['db_server']
    @@db_port = CONFIG[ENV["RACK_ENV"]]['dbconfig']['db_port']
    @@db_user = CONFIG[ENV["RACK_ENV"]]['dbconfig']['db_user']
    @@db_pass = CONFIG[ENV["RACK_ENV"]]['dbconfig']['db_pass']
    @@db_name = CONFIG[ENV["RACK_ENV"]]['dbconfig']['db_name']

    @pool = ConnectionPool.new(size: 3, timeout: 5) do
        conn = Mysql.new(@@db_server, @@db_user, @@db_pass, @@db_name, @@db_port)
        conn.query("SET NAMES UTF8")
        conn
    end
    # 下面的方法从 connection_pool 暴露出来的
    class << self
        # 使用闭包的形式调用
        def with(&block)
          @pool.with &block
        end
        # 直接调用
        def method_missing(name, *args, &block)
          @pool.with do |connection|
            connection.send(name, *args, &block)
          end
        end
    end
end #end class DB

sessioned = Rack::Session::Pool.new(BulkMail.new)
run sessioned
#run BulkMail