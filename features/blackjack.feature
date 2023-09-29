Feature: Playing a game of Blackjack

  Scenario: Player wins by having a higher hand value
    Given the initial bank for the player is 100
    And the initial bank for the dealer is 100
    When the game starts
    And the player chooses to add a card
    And the player chooses to skip
    And the dealer chooses to add a card
    And the dealer chooses to skip
    Then the game should end
    And the final bank for the player should be 110
    And the final bank for the dealer should be 90

  Scenario: Player goes bust
    Given the initial bank for the player is 100
    And the initial bank for the dealer is 100
    When the game starts
    And the player chooses to add a card
    And the player chooses to add a card
    And the player chooses to add a card
    Then the game should end
    And the final bank for the player should be 90
    And the final bank for the dealer should be 110

  Scenario: Dealer wins by having a higher hand value
    Given the initial bank for the player is 100
    And the initial bank for the dealer is 100
    When the game starts
    And the player chooses to skip
    And the dealer chooses to add a card
    And the dealer chooses to add a card
    And the dealer chooses to skip
    Then the game should end
    And the final bank for the player should be 90
    And the final bank for the dealer should be 110

  Scenario: Dealer goes bust
    Given the initial bank for the player is 100
    And the initial bank for the dealer is 100
    When the game starts
    And the player chooses to skip
    And the dealer chooses to add a card
    And the dealer chooses to add a card
    And the dealer chooses to add a card
    Then the game should end
    And the final bank for the player should be 110
    And the final bank for the dealer should be 90
