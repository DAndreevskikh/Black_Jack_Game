# frozen_string_literal: true

class Deck
  SUITS = ['<3', '<>', '*', '+'].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

  def initialize
    @cards = build_deck
    shuffle
  end

  def shuffle
    @cards.shuffle!
  end

  def draw
    @cards.pop
  end

  private

  def build_deck
    SUITS.product(RANKS).map { |suit, rank| Card.new(rank, suit) }
  end
end
