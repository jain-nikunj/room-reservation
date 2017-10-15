Feature: 
    
    As a Berkeley student, 
    I want to check if I can book a room in Evans for our study group. 

Scenario: display a map of Berkeley campus with buildings
    Given I am on the "homepage" 
    When I click on "Evans building"
    Then I should see "Number of rooms available"
    