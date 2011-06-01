ROOT = File.join(File.dirname(__FILE__), '..')

require "rubygems"
require "active_record"
require "database_cleaner"

Dir["#{ROOT}/lib/**/*.rb"].each{ |f| require f }
Dir["#{ROOT}/specs/**/*.rb"].each{ |f| require f }