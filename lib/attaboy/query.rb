class Query
  def initialize(query_string, validator_trigger)
    @query_string      = query_string
    @validator_trigger = validator_trigger
  end
  
  def statement
    @query_string
  end
  
  def trigger
    @validator_trigger
  end
end