require 'rubygems'
require 'bundler/setup'
# require 'goliath'
require 'em-synchrony/activerecord'
require 'grape'
require 'acts_as_list'
require 'state_machine'
require 'kaminari/grape'
require 'geocoder'
require 'pusher'
require 'sunspot'
require 'resque'

RESQUE = YAML::load(File.open('config/resque.yml'))['development']

require File.dirname(__FILE__) + '/database_configuration.rb'
require File.dirname(__FILE__) + '/action_mailer_configuration.rb'
require File.dirname(__FILE__) + '/solr_configuration.rb'


Dir[File.dirname(__FILE__) + '/lib/notification_adapters/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/calculator/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/contexts/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/roles/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/mailers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/workers/*.rb'].each {|file| require file }

# Setup redis
Resque.redis = Redis.new(
    :host => RESQUE['redis_host'],
    :port => RESQUE['redis_port']
)

order = Order.find(2363)

p Resque.enqueue(ReadyMailer, order, order.customer.email)