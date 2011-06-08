class ConstraintsProcessor
  def initialize(model_class)
    @model_class      = model_class
    @model_validators = model_class.validators
    @output           = {}
  end
  
  def run
    check_database_constraints(@model_validators)
    print_summary
  end
  
  def check_database_constraints(model_validators)
    model_validators.each do |validator|
      check_database_constraints_for_validator(@model_class, validator)
    end
  end
  
  def check_database_constraints_for_validator(model_class, model_validator)
    queries        = QueryBuilder.build_queries_for_model_validator(model_class, model_validator)
    query_executor = QueryExecutor.new(@model_class, queries, @output)
    query_executor.run
  end
  
  def print_summary
  end
end