require 'rubygems'
require 'bundler/setup'

ROOT_PATH = File.expand_path File.dirname(__FILE__)
require File.join(ROOT_PATH, 'lib/geocoder_job')

Bundler.require
f = File.open("#{ROOT_PATH}/data/addresses_example.csv")
f.each do |line|
  line = line.gsub("\n",'')
  Resque.enqueue(GeocoderJob, line, "#{ROOT_PATH}/data/result.csv")
end
