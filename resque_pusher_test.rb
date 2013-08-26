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

order = Order.find(2363)

message = "Your order: #{order.number} is being cooked up at #{order.store.store_name} and will be ready in #{order.time_to_ready} minutes."

# Resque.enqueue(NotificationPusherSender, 'in_progress_event', order.customer.id, order.id, message)
p Resque.enqueue(NotificationPusherSender, 'new_order_event', 9999999999, order.id, "New Order: ID #{order.id} at #{order.store.store_name} orderd at #{order.created_at}.")
