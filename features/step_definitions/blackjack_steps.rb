# frozen_string_literal: true

require_relative '/home/dmitry/Black_Jack_Game/card'
require_relative '/home/dmitry/Black_Jack_Game/deck'
require_relative '/home/dmitry/Black_Jack_Game/game'
require_relative '/home/dmitry/Black_Jack_Game/player'

Before do
  @game = Game.new('Player', 100, 100)
end

Given('the initial bank for the player is {int}') do |bank|
  @game.player.bank = bank
end

Given('the initial bank for the dealer is {int}') do |bank|
  @game.dealer.bank = bank
end

When('the player chooses to add a card') do
  @game.player_turn_choice = 'add_card'
end

When('the player chooses to skip') do
  @game.player_turn_choice = 'skip'
end

When('the dealer chooses to add a card') do
  @game.dealer_turn_choice = 'add_card'
end

When('the dealer chooses to skip') do
  @game.dealer_turn_choice = 'skip'
end

Then('the game should end') do
  @game.start
  expect(@game.player.bank).to be >= 0
  expect(@game.dealer.bank).to be >= 0
  expect(@game.player.bank).not_to eq(100)
  expect(@game.dealer.bank).not_to eq(100)
end

Then('the final bank for the player should be {int}') do |bank|
  @game.start
  expect(@game.player.bank).to eq(bank)
end

Then('the final bank for the dealer should be {int}') do |bank|
  @game.start
  expect(@game.dealer.bank).to eq(bank)
end
