require File.join(File.dirname(__FILE__), 'spec_helper')

describe ConstraintsProcessor do
  describe :initialize do
    let(:some_model) { mock("Some model") }
  
    it "gets all the validators used within that model class" do
      some_model.should_receive(:validators)
      ConstraintsProcessor.new(some_model)
    end
  end
  
  describe :run do
    let(:validators)            { mock("Model validators") }
    let(:some_model)            { mock("Some model", :validators => validators) }
    let(:constraints_processor) { ConstraintsProcessor.new(some_model) }
    
    before :each do
      constraints_processor.stub!(:check_database_constraints)
      constraints_processor.stub!(:print_summary)
    end
    
    it "checks the constraints on the database for the validators list" do
      constraints_processor.should_receive(:check_database_constraints).with(validators)
      constraints_processor.run
    end
    
    it "prints the summary" do
      constraints_processor.should_receive(:print_summary)
      constraints_processor.run
    end
  end
  
  describe :check_database_constraints do
    let(:validators)            { [mock("Valitator1"), mock("Valitator2"), mock("Valitator3")] }
    let(:some_model)            { mock("Some model", :validators => validators) }
    let(:constraints_processor) { ConstraintsProcessor.new(some_model) }
    
    it "checks the database constraints for each validator" do
      validators.each do |validator|
        constraints_processor.should_receive(:check_database_constraints_for_validator).with(some_model, validator)
      end
      constraints_processor.check_database_constraints(validators)
    end
  end
  
  describe :check_database_constraints_for_validator do
    let(:validator)             { mock("Valitator") }
    let(:some_model)            { mock("Some model", :validators => [validator]) }
    let(:constraints_processor) { ConstraintsProcessor.new(some_model) }
    let(:queries)               { mock("Queries") }
    
    before :each do
      QueryBuilder.stub!(:build_queries_for_model_validator => queries)
      queries.stub!(:run)
    end
    
    it "builds the query for that validator" do
      QueryBuilder.should_receive(:build_queries_for_model_validator).with(some_model, validator)
      constraints_processor.check_database_constraints_for_validator(some_model, validator)
    end
    
    it "runs the query" do
      queries.should_receive(:run)
      constraints_processor.check_database_constraints_for_validator(some_model, validator)
    end
  end
end