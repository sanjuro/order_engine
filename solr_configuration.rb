require 'sunspot'
require File.dirname(__FILE__) + '/lib/sunspot/active_record_adapter'

sunspotconfig = YAML::load(File.open(File.dirname(__FILE__) + '/config/sunspot.yml'))

url = sunspotconfig['production']['solr']['url']
port = sunspotconfig['production']['solr']['port']
path = sunspotconfig['production']['solr']['path']

Sunspot.config.solr.url = "#{url}:#{port}#{path}"