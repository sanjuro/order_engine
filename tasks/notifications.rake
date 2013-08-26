Dir[File.dirname(__FILE__) + '/../lib/notification_adapters/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/../lib/notification.rb'].each {|file| require file }

# :notifications task
# rake notifications:open_stores
#
desc "Send Notification"
task :send_notification do
	p ENV["DEVICE_TYPE"]
	exit
    Notification.adapter = ENV["DEVICE_TYPE"]
	Notification.send(ENV["DEVICE_TOKEN"], ENV["MESSAGE"])
end