Feature: User can issue rovers to crawl Mars
  As a user
  I want to send rovers and issue them commands
  So that I can explore the Mars grid world thoroughly

  Background: Successful first rover order issuing without any lost
    Given The world has been created with 5 and 3 limits
    When I create a new rover at 1 and 1 with an orientation of "E"
    And I issue "RFRFRFRF" to that rover
    Then I should see the following "1 1 E" from that rover

  Scenario: Sequential rover order issuing with a lost rover
    And I create another rover at 3 and 2 with an orientation of "N"
    And I issue "FRRFLLFFRRFLL" to that rover
    Then I should see the following "3 3 N LOST" from that robot considering it fell off the grid
    And I create a final rover at 0 and 3 with an orientation of "W"
    And I issue "LLFFFLFLFL" to that rover
    Then It should ignore a forward command at the last robot's final position 3,3 and "N" orientation
    And I should see the following "2 3 S" from that last rover

  Scenario Outline: Unsuccessful rover order issuing due to invalid user input
    Given The world has been created with 5 and 3 limits
    When I create a new rover at 1 and 1 with an orientation of "E"
    Then I should see an ArgumentError once I issue an invalid <input> command

    Examples:
    | input |
    | BDD   |
    | 12345 |

  Scenario Outline: Unsuccessful rover spawning due to invalid user input
    Given The world has been created with 5 and 3 limits
    When I create a new invalid rover at <x> and <y> with an orientation of "<orientation>"
    Then I should see an ArgumentError once I attempt to spawn it at that location

    Examples:
    | x | y | orientation |
    | -1 | 0 | E          |
    | 0  | 50 | E         |
    | 1  | 1  | B         |
