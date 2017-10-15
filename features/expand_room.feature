Feature: expandable room list

    As a Berkeley students,
    I want to check if I want to book a room in evans 
    and I do not waste time on the other rooms' information.
    
Scenario: display a map of Berkeley campus with buildings
    Given I am on the "homepage"
    And Room "70" of "Evans building" is available
    And Room "10" of "Evans building" is not available
    When I click on "Evans building"
    Then I should see "Expand" after room "70"
    But I should not see "Expand" after room "10"