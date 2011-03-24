#require 'config/setup_load_paths'
require 'lib/parkit'

set :environment, ENV['RACK_ENV'].to_sym
run ParkItApp