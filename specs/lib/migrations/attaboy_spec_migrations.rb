class AttaboySpecMigrations
  def self.create_test_attributes
    ActiveRecord::Schema.define(:version => 1) do
      create_table :test_attributes do |t|
        t.string   :a_string
        t.text     :a_text
        t.integer  :an_integer
        t.float    :a_float
        t.decimal  :a_decimal
        t.datetime :a_datetime
        t.time     :some_time
        t.date     :a_date
        t.binary   :some_binary_data
        t.boolean  :a_boolean
      end
    end
  end
end