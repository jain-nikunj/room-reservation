Feature: show room capacity and facilities

    As a Berkeley Student
    So that I can decide which room fits my needs
    I want to see "Capacity" and "Facilities" of any selected room
    
Scenario: show "Capacity" and "Facilities" under room details page
    Given I am on the "homepage" 
    And I click on "Haas Faculty Wing"
    And I click on room "F295"
    Then I should see "Capacity" to be "299
    And I should see "ADA-Instructor Accessible" under "Facilities"
