require File.join(File.dirname(__FILE__), 'spec_helper')

describe DataFactory do
  describe :generate_random_value_for do
    let(:column_type) { mock("Column type") }
    
    it "returns a random value for the column type" do
      DataFactory.generate_random_value_for(column_type).should_not be_nil
    end
  end
end