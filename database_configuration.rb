require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'

dbconfig = YAML::load(File.open(File.dirname(__FILE__) + '/config/database.yml'))
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(File.open(File.dirname(__FILE__) + '/log/database.log', 'a'))