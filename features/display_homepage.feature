Feature: display map with available buildings on the homepage
    
    As a Berkeley student, 
    when I open the Room Reservation App homepage, 
    then I should see a map of the Berkeley campus with buildings

Scenario: display a map of Berkeley campus with buildings
    Given I am on the "homepage" 
    Then I should see the "Berkeley campus map"
    And I should see the "Wheeler" building.
    