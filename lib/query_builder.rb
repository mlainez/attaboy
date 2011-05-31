class QueryBuilder
  PRESENCE_VALIDATOR = ActiveModel::Validations::PresenceValidator
  
  def self.build_queries_for_model_validator(model_class, model_validator)
    columns            = model_class.columns
    table_name         = model_class.table_name
    validator_class    = model_validator.class
    validator_triggers = model_validator.attributes
    attributes         = generate_attributes_for_columns(columns)
    build_queries_for_attributes_triggers_and_validator_type(table_name, attributes, validator_triggers, validator_class)
  end
  
  def self.generate_attributes_for_columns(table_columns)
    table_columns.inject({}) do |generated_attributes, column|
      column_type                       = column.type
      column_name                       = column.name
      generated_value                   = DataFactory.generate_random_value_for(column_type)
      generated_attributes[column_name] = generated_value
      generated_attributes
    end
  end
  
  def self.build_queries_for_attributes_triggers_and_validator_type(table_name, attributes, triggers, validator_class)
    if validator_class.instance_of?(PRESENCE_VALIDATOR)
      triggers.inject([]) do |queries, trigger|
        queries << create_null_insert_query_for_attributes_and_trigger(table_name, attributes, trigger)
        queries
      end
    end
  end
  
  def self.create_null_insert_query_for_attributes_and_trigger(table_name, attributes, trigger)
    keys   = attributes.keys
    values = attributes.values
    "INSERT into #{table_name} (#{keys.join(',')})"+" VALUES(#{values.join(',')})"
  end
end