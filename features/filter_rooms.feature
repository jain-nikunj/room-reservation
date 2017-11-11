Feature: Filter rooms with criteria using checkboxes
    
    As a Berkeley student,
    So that I can see rooms which satisfy my needs
    I want to filter rooms by various criteria
    
Background: rooms have been added to database

  Given the following buildings exist:
  | name                   | misc |
  | Haas Faculty Wing      |      |

  And the following rooms exist:
  | number     | capacity   | building_id  | facilities                        | misc                    |
  | F295       | 299        | 1            | ADA-Student Accessible            | Lecture Hall            |
  | F269       | 100        | 2            | Whiteboard, Chalkboard            | Classroom, Seminar Hall |
  | F110       | 50         | 3            | AV-Connection-Aux                 | Lecture Hall            |
  | F123       | 30         | 3            | ADA-Student Accessible            | Auditorium              |

  And  I am on the RoomReservation home page
  And  I am logged in as "john.doe@berkeley.edu", "John Doe"

Scenario: show filters on homepage
    Then I should see "Filters"
    And I should see "Student Accessible"
    And I should see "Board"
    And I should see "Capacity"
    And I should see "Classroom"
    And I should see "Lecture Hall"
    And I should see "Auditorium"
    And I should see "Seminar Room"
    And I should see "AV"
    
Scenario: limit by Student Accessible
    When I check "Student Accessible"
    Then I should see room "F295"
    And I should not see room "F269"
 
Scenario: limit by Board
    When I check "Board"
    Then I should see room "F269"
    And I should not see room "F295"

Scenario: limit by Room Type
    When I select "Lecture Hall"
    Then I should see room "F295"
    And I should not see room "F269"
    
Scenario: limit by AV-*
    When I check "AV-*"
    Then I should see room "F110"
    And I should not see room "F295"
    And I should not see room "F269"
    
Scenario: limit by Capacity
    When I fill in "Lower Bound" with "20"
    And I fill in "Upper Bound" with "60"
    Then I should see room "F110"
    And I should see room "F123"
    
Scenario: limit by multiple
    When I check "Lecture Hall"
    And I check "Auditorium"
    Then I should see room "F295"
    And I should see room "F110"
    And I should see room "F123"