require File.join(File.dirname(__FILE__), 'spec_helper')

describe QueryExecutor do
  describe :run do
    let(:model_class)    { mock("Model class") }
    let(:queries)        { [mock("Query"), mock("Query")] }
    let(:output)         { mock("Output") }
    let(:query_executor) { QueryExecutor.new(model_class, queries, output) }
    
    before :each do
      query_executor.stub!(:execute_query)
    end
    
    it "checks if there are multiple queries" do
      queries.should_receive(:is_a?).with(Array)
      query_executor.run
    end
    
    context "when there are multiple queries" do
      before :each do
        queries.stub!(:is_a? => true)
      end
      
      it "executes each query" do
        queries.each do |query|
          query_executor.should_receive(:execute_query).with(query)
        end
        query_executor.run
      end
    end
    
    context "when there is one or no query" do
      let(:query)          { mock("Query") }
      let(:query_executor) { QueryExecutor.new(model_class, query, output) }

      
      before :each do
        queries.stub!(:is_a? => false)
      end
      
      it "executes the query" do
        query_executor.should_receive(:execute_query).with(query)
        query_executor.run
      end
    end
  end
  
  describe :execute_query do
    let(:model_class)    { mock("Model class") }
    let(:query)          { mock("Query") }
    let(:query_string)   { mock("Query String") }
    let(:query_executor) { QueryExecutor.new(model_class, query, {}) }
    let(:connection)     { mock("Connection") }
    
    before :each do
      model_class.stub!(:transaction).and_yield
      ActiveRecord::Base.stub!(:connection => connection)
      connection.stub!(:execute)
      query_executor.stub!(:log_passing_query)
      query_executor.stub!(:log_failing_query)
      query_executor.stub!(:raise)
      query.stub!(:statement => query_string)
    end
    
    it "gets the activerecord connection" do
      ActiveRecord::Base.should_receive(:connection)
      query_executor.execute_query(query)
    end
    
    it "opens a transaction" do
      model_class.should_receive(:transaction)
      query_executor.execute_query(query)
    end
    
    it "gets the statement of the query" do
      query.should_receive(:statement)
      query_executor.execute_query(query)
    end
    
    it "executes the query" do
      connection.should_receive(:execute).with(query_string)
      query_executor.execute_query(query)
    end
    
    context "when the query fails" do
      before :each do
        connection.stub!(:execute).and_raise(ActiveRecord::StatementInvalid)
      end
      
      it "considers it as a proof that there is a corresponding constraint on the database" do
        query_executor.should_receive(:log_failing_query).with(query)
        query_executor.execute_query(query)
      end
    end
    
    context "when the query doesn't fail" do
      it "considers it a proof that there is no corresponsing constraint on the database" do
        query_executor.should_receive(:log_passing_query).with(query)
        query_executor.execute_query(query)
      end
      
      it "raises a RollbackException" do
        query_executor.should_receive(:raise).with(ActiveRecord::Rollback)
        query_executor.execute_query(query)
      end
    end
  end
  
  describe :log_passing_query do
    let(:model_class)    { mock("Model class") }
    let(:query)          { mock("Query") }
    let(:trigger)        { mock("Trigger") }
    let(:output)         { mock("Output") }
    let(:errors)         { mock("Errors") }
    let(:query_executor) { QueryExecutor.new(model_class, query, output) }
    
    before :each do
      query.stub!(:trigger => trigger)
      output.stub!(:[] => errors)
    end
    
    it "adds a message to the error logger" do
      errors.should_receive(:<<).with("Insert request with null #{trigger} for #{model_class} was not expected to pass")
      query_executor.log_passing_query(query)
    end
  end
end