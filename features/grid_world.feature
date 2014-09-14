Feature: Create a new x,y grid world
  As a user
  I want to enter the x and y string limits of the world
  So that the grid world is created with those limits for the mars rover

  Scenario Outline: User enters input for world boundaries
    Given The user has been prompted for co-ordinates
    When The user enters the world <x> and <y> boundaries
    Then The world should be created with those values
    But The world should not be created if the value of any co-ordinate exceeds 50, is equal or below 0 or the entered input is not a number
    And The user should see the following <output>

  Examples:
    | x | y | output |
    | 0 | 0 | Please enter valid world limits above 0,0 and between 50,50 |
    | 1 | 1 | The mars world grid has been created with (1,1) dimensions |
    | 2 | 3 | The mars world grid has been created with (2,3) dimensions |
    | 50 | 50 | The mars world grid has been created with (50,50) dimensions |
    | 52 | 50 | Please enter valid world limits above 0,0 and between 50,50  |
    | hello | 0 | Please enter valid world limits above 0,0 and between 50,50 |
    | hello | hello | Please enter valid world limits above 0,0 and between 50,50 |
    | myw | you | Please enter valid world limits above 0,0 and between 50,50 |
