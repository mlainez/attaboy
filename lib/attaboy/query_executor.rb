class QueryExecutor
  def initialize(model_class, queries, output)
    @model_class = model_class
    @queries     = queries
    @output      = output
  end
  
  def run
    @queries = [@queries] unless @queries.is_a?(Array)
    @queries.each do |query|
      execute_query(query)
    end
  end
  
  def execute_query(query)
    database_connection = ActiveRecord::Base.connection
    @model_class.transaction do
      begin
        query_string = query.statement
        database_connection.execute(query_string)
        log_passing_query(query)
        raise ActiveRecord::Rollback
      rescue ActiveRecord::StatementInvalid
        log_failing_query(query)
      end
    end
  end
  
  def log_passing_query(query)
    message = "Insert request with null #{query.trigger} for #{@model_class} was not expected to pass"
    @output[:error] ||= []
    @output[:error] << message
  end
end