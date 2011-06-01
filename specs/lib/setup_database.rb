ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.configurations = true

AttaboySpecMigrations.create_test_attributes

DatabaseCleaner.strategy = :truncation