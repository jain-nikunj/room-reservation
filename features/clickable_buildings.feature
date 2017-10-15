Feature: display rooms in a specific building

    As a Berkeley student, when I click the Evans building,
    then I should see all the rooms in Evans as a pop-up dialog box.
    
Scenario: display rooms in Evans building
    Given I am on the "homepage" 
    and I click on "Evans building"
    Then I should see "Available rooms in Evans"