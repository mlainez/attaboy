require File.join(File.dirname(__FILE__), 'spec_helper')

describe Query do
  describe :statement do
    let(:query_string)      { mock("Query string") }
    let(:validator_trigger) { mock("Validator") }
    let(:query)             { Query.new(query_string, validator_trigger) }
    
    it "returns the query string" do
      query.statement.should eq query_string
    end
  end
  
  describe :validator_trigger do
    let(:query_string)      { mock("Query string") }
    let(:validator_trigger) { mock("Validator") }
    let(:query)             { Query.new(query_string, validator_trigger) }
    
    it "returns the validator trigger" do
      query.trigger.should eq validator_trigger
    end
  end
end