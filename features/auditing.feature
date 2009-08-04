Feature: Auditing Events

  Background: 
    Given I am logged in as "admin"

  Scenario: Viewing a custom report for an object that exists
    When I go to the audit report for page "News"
    Then I should see "News"
    And I should see a link to edit page "News"
    
  Scenario: Viewing a custom report for an object that used to exist
    Given I delete page "News"
    When I go to the audit report for page "News"
    Then I should see "News"
    And I should see "\(deleted\)"
    And I should not see a link to edit page "News"