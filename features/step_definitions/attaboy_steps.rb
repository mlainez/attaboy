Given /^I have a model with a presence validator$/ do
  @model = SomeModel
end

When /^I execute attaboy$/ do
  @attaboy = Attaboy.new(@model)
end

Then /^I should see "([^"]*)"$/ do |words|
  pending
end
