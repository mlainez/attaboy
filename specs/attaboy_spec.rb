require File.join(File.dirname(__FILE__), 'spec_helper')

describe Attaboy do
  let(:some_model)            { mock("Some model") }
  let(:constraints_processor) { mock("Some processor") }
  
  before :each do
    ConstraintsProcessor.stub!(:new => constraints_processor)
    constraints_processor.stub!(:run => nil)
  end
  
  it "creates a new model constraints processor for the model passed as param" do
    ConstraintsProcessor.should_receive(:new).with(some_model).and_return(constraints_processor)
    Attaboy.new(some_model)
  end
  
  it "tells the constraints processor to run" do
    constraints_processor.should_receive(:run)
    Attaboy.new(some_model)
  end
end