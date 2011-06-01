class SomeModel < ActiveRecord::Base
  set_table_name :test_attributes
  
  validates_presence_of :a_string
end