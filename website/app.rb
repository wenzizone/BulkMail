# encoding: utf-8 
require 'rubygems'
require 'sinatra'
require 'slim'
require 'json'
require 'yaml'
require 'gearman'

ruby_ver = RUBY_VERSION
if ruby_ver.to_f == 1.8
	require 'extensions/all'
end

ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined?ROOT_DIR
# 拼接路径
def root_path(*args)
	File.join(ROOT_DIR, *args)
end

CONFIG = YAML.load_file(ROOT_DIR+"/config/config.yml")

# send trashemail app
class BulkMail < Sinatra::Application
	configure do
		set :app_file, __FILE__
		set :root, ROOT_DIR
		set :public_folder, root_path('static')
		set :views, root_path('app', 'views')
		set :upload, root_path('uploads')
		set :config, CONFIG
		disable :sessions
		#use Rack::Session::Pool, :expire_after => 10, :secret => 'BulkMail', :domain => 'localhost'
		Log = Logger.new('sinatra.log')
		Log.level = Logger::DEBUG
	end

	configure :production do
		set :show_excepitons, false
		set :raise_errors, false
		#set :sessions, false
		set :static, true
		#use Rack::Session::Pool, :expire_after => 2592000, :secret => 'BulkMail'
		#Mongoid.load!(root_path('config','_mongoid.yml'),:production)
		#require "sinatra/reloader"
		#also_reload root_path('app','**/*.rb')
	end

	configure :development do
		set :show_exceptions, true
		set :raise_errors, true
		#set :sessions, false
		set :static, true
		disable :sessions
		use Rack::Session::Pool, :expire_after => 10, :secret => 'BulkMail'
		#Mongoid.load!(root_path('config','_mongoid.yml'),:development)
		require "sinatra/reloader"
		also_reload root_path('app','**/*.rb')
	end

	helpers do
		include Rack::Utils
	end
end

if ruby_ver.to_f == 1.8
	require root_path('app','helpers','init')
	require root_path('app','models','init')
	require root_path('app','routes','init')
else
	require_relative root_path('app','helpers','init')
	require_relative root_path('app','models','init')
	require_relative root_path('app','routes','init')
end

