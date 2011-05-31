SPEC_DIR         = File.dirname(__FILE__)
lib_path         = File.expand_path("#{SPEC_DIR}/../lib")
migrations_path  = File.expand_path("#{SPEC_DIR}/fixtures/migrations")
test_models_path = File.expand_path("#{SPEC_DIR}/fixtures/models")

$LOAD_PATH.unshift lib_path         unless $LOAD_PATH.include?(lib_path)
$LOAD_PATH.unshift migrations_path  unless $LOAD_PATH.include?(migrations_path)
$LOAD_PATH.unshift test_models_path unless $LOAD_PATH.include?(test_models_path)

require "rubygems"
require "active_record"
require "database_cleaner"

Dir[File.join(lib_path, "*.rb")].each {|file| require File.basename(file) }
Dir[File.join(migrations_path, "*.rb")].each {|file| require File.basename(file) }
Dir[File.join(test_models_path, "*.rb")].each {|file| require File.basename(file) }

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.configurations = true

AttaboySpecMigrations.create_test_attributes

DatabaseCleaner.strategy = :truncation