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

# resque-web config/redis.rb -L
# bundle exec rake resque:work MODE=development TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 COUNT=1 QUEUE=* VERBOSE=1 PIDFILE=tmp/pids/resque_worker.pid  >> log/resque_worker_QUEUE.log
# MODE=productiom COUNT=2 QUEUE=*  VERBOSE=1 TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 bundle exec rake resque:work >> log/resque_worker_QUEUE.log --trace
namespace :resque do

    # :setup task
    #
    desc "Setup a Resque worker"
    task :setup do
        require 'state_machine'

        RESQUE = YAML::load(File.open('config/resque.yml'))[ENV['MODE']]

		require File.dirname(__FILE__) + '/../database_configuration.rb'
		require File.dirname(__FILE__) + '/../action_mailer_configuration.rb'
		require File.dirname(__FILE__) + '/../solr_configuration.rb'
       
        Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }
        Dir[File.dirname(__FILE__) + '/../lib/notification_adapters/*.rb'].each {|file| require file }
        Dir[File.dirname(__FILE__) + '/../app/helpers/*.rb'].each {|file| require file }
		Dir[File.dirname(__FILE__) + '/../app/models/*.rb'].each {|file| require file }        
        Dir[File.dirname(__FILE__) + '/../app/models/calculator/*.rb'].each {|file| require file }
        Dir[File.dirname(__FILE__) + '/../app/models/gateway/*.rb'].each {|file| require file }
        Dir[File.dirname(__FILE__) + '/../app/models/payment_method/*.rb'].each {|file| require file }        
		Dir[File.dirname(__FILE__) + '/../app/contexts/*.rb'].each {|file| require file }
		Dir[File.dirname(__FILE__) + '/../app/roles/*.rb'].each {|file| require file }
		Dir[File.dirname(__FILE__) + '/../app/mailers/*.rb'].each {|file| require file }
		Dir[File.dirname(__FILE__) + '/../app/workers/*.rb'].each {|file| require file }
    end

    # :work task
    #
    desc "Start a Resque worker"
    task :work => [:setup] do
        require 'resque'

        # Configure logging
        Resque.logger = Logger.new(RESQUE['log_file'])
        Resque.logger.level = Logger::WARN

        # Setup redis
        Resque.redis = Redis.new(
            :host => RESQUE['redis_host'],
            :port => RESQUE['redis_port']
        )

        queues = (ENV['QUEUES'] || ENV['QUEUE'] || RESQUE['queue']).to_s.split(',')


        begin
            worker = Resque::Worker.new(*queues)
            worker.term_timeout = ENV['RESQUE_TERM_TIMEOUT'] || 4.0
            worker.term_child = ENV['TERM_CHILD'] || RESQUE['term_child']
        rescue Resque::NoQueueError
            abort "set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work"
        end

        if ENV['BACKGROUND']
            unless Process.respond_to?('daemon')
                abort "env var BACKGROUND is set, which requires ruby >= 1.9"
            end
            Process.daemon(true)
        end

        if ENV['PIDFILE'] || RESQUE['pid_file']
            pid_file = ENV['PIDFILE'] || RESQUE['pid_file']
            File.open(pid_file, 'w') { |f| f << worker.pid }
        end

        worker.log "Starting worker #{worker}"
        worker.work(ENV['INTERVAL'] || RESQUE['interval'] || 5) # interval, will block
    end
end