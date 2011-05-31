class Attaboy
  def initialize(model_class)
    constraints_processor = ConstraintsProcessor.new(model_class)
    constraints_processor.run
  end
end