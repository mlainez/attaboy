class QueryBuilder
  
  def self.build_query_for_model_validator(model_class, model_validator)
    columns    = model_class.columns
    attributes = build_attributes_for_columns_and_validator(columns, model_validator)
    build_required_query_from_attributes_and_validator(attributes, model_validator)
  end
  
  def self.build_attributes_for_columns_and_validator(table_columns, model_validator)
    generated_attributes = generate_data_for_columns(table_columns)
    morph_data_for_validator!(generated_attributes, model_validator)
  end
  
  def self.generate_data_for_columns(table_columns)
    table_columns.inject({}) do |generated_attributes, column|
      column_type                       = column.type
      column_name                       = column.name
      generated_value                   = DataFactory.generate_random_value_for(column_type)
      generated_attributes[column_name] = generated_value
      generated_attributes
    end
  end
end