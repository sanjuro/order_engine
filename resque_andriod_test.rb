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

class Repository
  def send_android_notification(device_token,message)
   Resque.enqueue(NotificationAndroidSender, 'android', device_token, message)
  end

end

order = Order.find(2363)

android_destination = "APA91bGCWoRKqS5d3PGLo7Sgw2sKfptk1ppzBkpKTw2O7F09pr7cBfc_B8mM5eZx1XUk105bRD6CIzihWEm3cfX5Xp9zW_b5aqhFEE8z2o2zkZVyhtbdmYCSVrbo_dBXnQwPgH5mk24uTIl721khxDikxdPT6aGHAQ"

order = Order.find(2363)

message = Hash.new
message[:order_id] = 2363
message[:subject] = "in progress order"
message[:msg] = "Your order: #{order.number} has been received and will be ready in #{order.time_to_ready} minutes."

p Resque.enqueue(NotificationAndroidSender, android_destination, order.id, message)