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

message = Hash.new
message[:order_id] = 2363
message[:msg] = "Your order: 24 is ready for collection at Steers Kromboom."
message[:updated_at] = "2013-06-03 12:47:28"
message[:store_order_number] = "24"
message[:state] = "ready"
message[:time_to_ready] = "15"

ios_destination = "43c3da656b09c4c20c4919183b884005a015347160789ca368614aa5a4e652aa"

p Resque.enqueue(NotificationIosSender, ios_destination, 2363, message)