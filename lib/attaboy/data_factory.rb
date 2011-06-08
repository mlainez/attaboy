require 'Faker'

class DataFactory
  def self.generate_random_value_for(column_type)
    case column_type
    when :string
      "'#{Faker::Lorem.sentence}'"
    when :text
      "'#{Faker::Lorem.paragraph}'"
    when :float
      rand(1000.0)
    when :decimal
      BigDecimal(rand(1000.0).to_s)
    when :datetime
      "'#{rand(10.years).ago}'"
    when :time
      "'#{Time.now}'"
    when :date
      "'#{rand(10.years).ago}'"
    when :boolean
      options = [1, 0]
      options[rand(options.size)]
    else
      rand(1000)
    end
  end
end