Feature: Visiting the site
  As a non-logged-in visitor
  I need to be told what the deal is
  So that I don't leave instantly

  Scenario: The homepage should allow me to create a soloist script
    Given some recipes have been created
    And I am on the homepage
    Then I should be able to create a soloist script