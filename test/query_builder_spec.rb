require File.join(File.dirname(__FILE__), 'spec_helper')

describe QueryBuilder do
  describe :build_queries_for_model_validator do
    let(:some_model)      { mock("Model") }
    let(:some_validator)  { mock("Validator") }
    let(:columns)         { mock("Columns") }
    let(:attributes)      { mock("Query attributes") }
    let(:queries)         { mock("Queries") }
    let(:triggers)        { mock("Triggers") }
    let(:validator_class) { mock("Class") }
    let(:table_name)      { mock("Table name") }
  
    before :each do
      some_model.stub!(:columns => columns)
      some_model.stub!(:table_name => table_name)
      QueryBuilder.stub!(:generate_attributes_for_columns => attributes)
      QueryBuilder.stub!(:build_queries_for_attributes_triggers_and_validator_type => queries)
      some_validator.stub!(:class => validator_class)
      some_validator.stub!(:attributes => triggers)
    end
  
    it "gets the database table columns from the model" do
      some_model.should_receive(:columns).and_return(columns)
      QueryBuilder.build_queries_for_model_validator(some_model, some_validator)
    end
    
    it "gets the table name for the model" do
      some_model.should_receive(:table_name)
      QueryBuilder.build_queries_for_model_validator(some_model, some_validator)
    end
  
    it "generates some dummy data for the attributes" do
      QueryBuilder.should_receive(:generate_attributes_for_columns).with(columns).and_return(attributes)
      QueryBuilder.build_queries_for_model_validator(some_model, some_validator)
    end
    
    it "gets the validator type" do
      some_validator.should_receive(:class)
      QueryBuilder.build_queries_for_model_validator(some_model, some_validator)
    end
    
    it "gets the attributes that trigger the validator" do
      some_validator.should_receive(:attributes)
      QueryBuilder.build_queries_for_model_validator(some_model, some_validator)
    end
  
    it "builds the required query based on the query attributes" do
      QueryBuilder.should_receive(:build_queries_for_attributes_triggers_and_validator_type).with(table_name, attributes, triggers, validator_class).and_return(queries)
      QueryBuilder.build_queries_for_model_validator(some_model, some_validator)
    end
  
    it "returns the query" do
      QueryBuilder.build_queries_for_model_validator(some_model, some_validator).should eql queries
    end
  end
  
  describe :generate_attributes_for_columns do
    let(:column1)         { mock("Column1", :name => "Name1", :type => :string) }
    let(:column2)         { mock("Column2", :name => "Name2", :type => :integer) }
    let(:columns)         { [column1, column2] }
    let(:generated_value) { mock("Generated value") }
    
    before :each do
      DataFactory.stub!(:generate_random_value_for => generated_value)
    end
    
    it "checks the type of each column" do
      columns.each do |column|
        column.should_receive(:type)
      end
      QueryBuilder.generate_attributes_for_columns(columns)
    end
    
    it "gets the name of each column" do
      columns.each do |column|
        column.should_receive(:name)
      end
      QueryBuilder.generate_attributes_for_columns(columns)
    end
    
    it "generates some random data for each specific column" do
      columns.each do |column|
        DataFactory.should_receive(:generate_random_value_for).with(column.type)
      end
      QueryBuilder.generate_attributes_for_columns(columns)
    end
    
    it "returns a hash containing the column name as key and the generated value" do
      attributes_hash = { columns.first.name => generated_value, columns.last.name => generated_value }
      QueryBuilder.generate_attributes_for_columns(columns).should eql attributes_hash
    end
  end
  
  describe :build_queries_for_attributes_triggers_and_validator_type do
    context "when the validator is a presence validator" do
      let(:validator_class) { mock("Validator Class") }
      let(:attributes)      { mock("Attributes") }
      let(:triggers)        { [mock("Trigger"), mock("Trigger2")] }
      let(:query)           { mock("Query") }
      let(:table_name)      { mock("Table name") }
      
      before :each do
        QueryBuilder.stub!(:create_null_insert_query_for_attributes_and_trigger => query)
      end
      
      it "checks if the validator is a presence validator" do
        validator_class.should_receive(:instance_of?).with(ActiveModel::Validations::PresenceValidator)
        QueryBuilder.build_queries_for_attributes_triggers_and_validator_type(table_name, attributes, triggers, validator_class)
      end
      
      context "when the validator is a presence validator" do
        before :each do
          validator_class.stub!(:instance_of? => true)
        end
        
        it "creates an SQL insert query with the attributes with the trigger set as NULL for each trigger" do
          triggers.each do |trigger|
            QueryBuilder.should_receive(:create_null_insert_query_for_attributes_and_trigger).with(table_name, attributes, trigger)
          end
          QueryBuilder.build_queries_for_attributes_triggers_and_validator_type(table_name, attributes, triggers, validator_class)
        end
        
        it "returns an array of queries" do
          queries = [query, query]
          QueryBuilder.build_queries_for_attributes_triggers_and_validator_type(table_name, attributes, triggers, validator_class).should eql queries
        end
      end
    end
    
    describe :create_null_insert_query_for_attributes_and_trigger do
      let(:attributes)      { mock("Attributes") }
      let(:trigger)         { mock("Trigger") }
      let(:keys)            { ["key1", "key2"] }
      let(:values)          { ["'value1'", "'value2'"] }
      let(:table_name)      { "Table" }
      
      before :each do
        attributes.stub!(:keys => keys)
        attributes.stub!(:values => values)
      end
      
      it "gets the keys from the attributes hash" do
        attributes.should_receive(:keys)
        QueryBuilder.create_null_insert_query_for_attributes_and_trigger(table_name, attributes, trigger)
      end
      
      it "gets the values from the attributes hash" do
        attributes.should_receive(:values)
        QueryBuilder.create_null_insert_query_for_attributes_and_trigger(table_name, attributes, trigger)
      end
      
      it "returns an insert sql query with the trigger NULL and the attributes as values" do
        query = "INSERT into #{table_name} (#{keys.join(',')})"+" VALUES(#{values.join(',')})"
        QueryBuilder.create_null_insert_query_for_attributes_and_trigger(table_name, attributes, trigger).should eql query
      end
    end
  end
end