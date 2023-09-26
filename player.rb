class Player
  attr_reader :name, :bank, :hand

  def initialize(name, bank)
    @name = name
    @bank = bank
    @hand = []
  end

  def add_to_hand(card)
    @hand << card
  end

  def hand_value
    total = @hand.sum { |card| card_value(card.rank) }
    aces = @hand.count { |card| card.rank == 'A' }

    while aces > 0 && total > 21
      total -= 10
      aces -= 1
    end

    total
  end

  def deduct_from_bank(amount)
    @bank -= amount
  end

  def add_to_bank(amount)
    @bank += amount
  end

  def clear_hand
    @hand = []
  end

  private

  def card_value(rank)
    if %w[J Q K].include?(rank)
      10
    elsif rank == 'A'
      11
    else
      rank.to_i
    end
  end
end
