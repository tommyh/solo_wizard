Feature: Visiting the site
  As a non-logged-in visitor
  I need to be told what the deal is
  So that I don't leave instantly

  Background:
    Given some recipes have been created
    And a default soloist script has been created

  Scenario: A soloist script example should be ready for me to try
    Given I am on the homepage
    Then there should be a real soloist script example

  Scenario: The homepage should allow me to create a soloist script
    Given I am on the homepage
    Then I should be able to create a soloist script