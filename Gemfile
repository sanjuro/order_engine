source 'https://rubygems.org'

gem 'pg'
gem 'em-postgresql-adapter', :git => 'git://github.com/leftbee/em-postgresql-adapter.git'
gem 'rack-fiber_pool',  :require => 'rack/fiber_pool'
gem 'em-synchrony', :git => 'git://github.com/igrigorik/em-synchrony.git',
                    :require => ['em-synchrony', 'em-synchrony/activerecord']
                            
gem 'grape'
gem 'goliath'

gem 'mysql2'

gem 'awesome_nested_set'

gem 'acts_as_list', '>= 0.1.0'

# gem 'acts_as_tenant'

# gem 'geocoder'

gem "state_machine"

gem 'devise'

group :test do 
	gem 'rake', :groups=>[:development, :test]
	gem 'rack-test', :group=>:test
	gem 'rspec', :group=>:test
	gem 'factory_girl'
	gem 'spork'
end