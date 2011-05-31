require File.join(File.dirname(__FILE__), 'spec_helper')

describe QueryBuilder do
  describe :build_query_for_model_validator do
    let(:some_model)     { mock("Model") }
    let(:some_validator) { mock("Validator") }
    let(:columns)        { mock("Columns") }
    let(:attributes)     { mock("Query attributes") }
    let(:query)          { mock("Query") }
  
    before :each do
      some_model.stub!(:columns => columns)
      QueryBuilder.stub!(:build_attributes_for_columns_and_validator => attributes)
      QueryBuilder.stub!(:build_required_query_from_attributes_and_validator => query)
    end
  
    it "gets the database table columns from the model" do
      some_model.should_receive(:columns).and_return(columns)
      QueryBuilder.build_query_for_model_validator(some_model, some_validator)
    end
  
    it "generates the attributes required for the query based on the model and the validator" do
      QueryBuilder.should_receive(:build_attributes_for_columns_and_validator).with(columns, some_validator).and_return(attributes)
      QueryBuilder.build_query_for_model_validator(some_model, some_validator)
    end
  
    it "builds the required query based on the query attributes" do
      QueryBuilder.should_receive(:build_required_query_from_attributes_and_validator).with(attributes, some_validator).and_return(query)
      QueryBuilder.build_query_for_model_validator(some_model, some_validator)
    end
  
    it "returns the query" do
      QueryBuilder.build_query_for_model_validator(some_model, some_validator).should eql query
    end
  end
  
  describe :build_attributes_for_columns_and_validator do
    let(:columns)        { mock("Columns") }
    let(:some_validator) { mock("Validator") }
    let(:generated_data) { mock("Generated data") }
    let(:morphed_data)   { mock("Morphed data") }
    
    before :each do
      QueryBuilder.stub!(:generate_data_for_columns => generated_data)
      QueryBuilder.stub!(:morph_data_for_validator! => morphed_data)
    end
    
    it "generates some dummy data for the attributes" do
      QueryBuilder.should_receive(:generate_data_for_columns).with(columns).and_return(generated_data)
      QueryBuilder.build_attributes_for_columns_and_validator(columns, some_validator)
    end
    
    it "morphes the generated attributes to trigger the validator" do
      QueryBuilder.should_receive(:morph_data_for_validator!).with(generated_data, some_validator).and_return(morphed_data)
      QueryBuilder.build_attributes_for_columns_and_validator(columns, some_validator)
    end
    
    it "returns the morphed attributes" do
      QueryBuilder.build_attributes_for_columns_and_validator(columns, some_validator).should eql morphed_data
    end
  end
  
  describe :generate_data_for_columns do
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
      QueryBuilder.generate_data_for_columns(columns)
    end
    
    it "gets the name of each column" do
      columns.each do |column|
        column.should_receive(:name)
      end
      QueryBuilder.generate_data_for_columns(columns)
    end
    
    it "generates some random data for each specific column" do
      columns.each do |column|
        DataFactory.should_receive(:generate_random_value_for).with(column.type)
      end
      QueryBuilder.generate_data_for_columns(columns)
    end
    
    it "returns a hash containing the column name as key and the generated value" do
      attributes_hash = { columns.first.name => generated_value, columns.last.name => generated_value }
      QueryBuilder.generate_data_for_columns(columns).should eql attributes_hash
    end
  end
end