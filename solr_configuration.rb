require 'sunspot'
require File.dirname(__FILE__) + '/lib/sunspot/active_record_adapter'

sunspotconfig = YAML::load(File.open(File.dirname(__FILE__) + '/config/sunspot.yml'))

url = sunspotconfig['development']['solr']['url']
port = sunspotconfig['development']['solr']['port']
path = sunspotconfig['development']['solr']['path']

Sunspot.config.solr.url = "#{url}:#{port}#{path}"