namespace :resque do

    # :work task
    #
    desc "Start a Resque worker"
    task :work => [:setup] do
        require 'resque'

        # Configure logging
        Resque.logger = Logger.new(RESQUE['log_file'])
        Resque.logger.level = Logger::INFO

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

    # :setup task
    #
    desc "Setup a Resque worker"
    task :setup do
        
        require 'state_machine'
        require 'yaml'
        YAML::ENGINE.yamler = 'syck'

        RESQUE = YAML::load(File.open('config/resque.yml'))

        require File.dirname(__FILE__) + '/config/database_configuration.rb'
        require File.dirname(__FILE__) + '/config/action_mailer_configuration.rb'

        # ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml')))
        # ActiveRecord::Base.logger = Logger.new(File.open(RESQUE['database_log'], 'a'))

        Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }
        Dir[File.dirname(__FILE__) + '/../workers/*.rb'].each { |file| require file }
    end

end
