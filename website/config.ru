require 'sinatra'

require './app'

configure do
    set :public_folder, File.dirname(__FILE__) + '/static'
    enable :public_folder
end

run BulkMail
