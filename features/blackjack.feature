Feature: Blackjack Game

  Background:
    Given a new game is started

  Scenario: Player skips the round
    When the player skips their turn
    Then the round should end without additional cards dealt
    And the dealer's turn should start

  Scenario: Player goes bust
    When the player adds a card
    And the player adds another card
    And the player adds a third card
    And the player adds a fourth card
    And the player opens their cards
    Then the round should end
    And the player should lose

  Scenario: Player and dealer tie
    When the player adds a card
    And the dealer adds a card
    And the player opens their cards
    And the dealer opens their cards
    Then the round should end in a tie

  Scenario: Player adds cards and wins with more than 100 in bank
    When the player adds a card
    And the player adds another card
    And the player adds a third card
    And the player opens their cards
    Then the round should end
    And the dealer should lose
    And the player's bank should be greater than 100
