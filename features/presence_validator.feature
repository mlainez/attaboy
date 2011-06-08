Feature: Oupout report for presence validator
  In order to make sure I keep a certain level of integrity in my database
  As a developer
  I want to get recommandation about the constraints I should put on my database
  
  Scenario: Ouput report with presence validator
    Given I have a model with a presence validator
    When I execute attaboy
    Then I should see "was not expected to pass"