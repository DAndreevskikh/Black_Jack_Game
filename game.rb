# frozen_string_literal: true

class Game
  attr_reader :player, :dealer

  def initialize(player_name = nil, player_bank = nil, dealer_bank = nil)
    @deck = Deck.new
    @player = Player.new(player_name || get_player_name, player_bank || 100)
    @dealer = Player.new('Dealer', dealer_bank || 100)
  end

  def start
    loop do
      break if @player.bank.zero?
      break if @dealer.bank.zero?

      deal_initial_cards
      player_turn
      take_bets
      dealer_turn unless @player.hand_value > 21
      end_game
      break unless play_again
    end
  end

  private

  def get_player_name
    puts 'Enter your name:'
    gets.chomp
  end

  def deal_initial_cards
    2.times do
      @player.add_to_hand(@deck.draw)
      @dealer.add_to_hand(@deck.draw)
    end
  end

  def take_bets
    @player.deduct_from_bank(10)
    @dealer.deduct_from_bank(10)
  end

  def open_cards
    @player.hand_value
    @dealer.hand_value
  end

  def player_turn
    loop do
      show_game_status
      choice = get_player_choice

      case choice
      when 'skip'
        break
      when 'add_card'
        if @player.hand_value <= 21
          new_card = @deck.draw
          @player.add_to_hand(new_card)
          adjust_ace_value if new_card.rank == 'A'
        else
          puts 'Invalid choice. You cannot add a card now.'
        end
      when 'open_cards'
        break
      else
        puts 'Invalid choice. Please choose "skip," "add_card," or "open_cards."'
      end
    end
    return unless @player.hand_value <= 21

    open_cards
  end

  def adjust_ace_value
    @player.hand.each do |card|
      if card.rank == 'A'
        if @player.hand_value + 11 <= 21
          card.value = 11
        else
          card.value = 1
        end
      end
    end
  end

  def show_game_status
    puts "Player's Bank: $#{@player.bank}"
    puts "Dealer's Bank: $#{@dealer.bank}"
    puts "Your Hand: #{hand_to_string(@player.hand)}"
    puts "Points: #{@player.hand_value}"

    return unless @player.hand_value <= 21

    puts 'Dealer:'
    puts '*** ***'
  end

  def hand_to_string(hand)
    hand.compact.map { |card| "#{card.rank}#{card.suit}" }.join(', ')
  end

  def get_player_choice
    puts 'Choose an action:'
    puts '1. Skip'
    puts '2. Add a card' if @player.hand.length == 2
    puts '3. Open cards'

    choice = nil
    loop do
      choice = gets.chomp
      break if %w[1 2 3].include?(choice)

      puts 'Invalid choice. Please choose "1" to Skip, "2" to Add a card, or "3" to Open cards.'
    end

    case choice
    when '1' then 'skip'
    when '2' then 'add_card'
    when '3' then 'open_cards'
    end
  end

  def dealer_turn
    while @dealer.hand_value < 17
      card = @deck.draw
      if card.nil?
        puts 'The deck is out of cards!'
        break
      else
        @dealer.add_to_hand(card)
      end
    end
  end

  def end_game
    if @player.hand_value <= 21
      show_result
      update_player_bank
    else
      puts 'Your hand is over 21. You lose!'
      @dealer.add_to_bank(20)
    end

    reset_game
  end

  def show_result
    player_score = @player.hand_value
    dealer_score = @dealer.hand_value

    puts 'Result:'
    puts "Your Hand: #{hand_to_string(@player.hand)}"
    puts "Your Points: #{player_score}"
    puts 'Dealer:'
    puts hand_to_string(@dealer.hand)
    puts "Dealer's Points: #{dealer_score}"

    if @player.bank.zero?
      puts 'Player is out of money. Please replenish your bank and come back.'
    elsif @dealer.bank.zero?
      puts 'The dealer is broke. You cleaned him out. Good job!'
    elsif player_score > 21 || (dealer_score <= 21 && dealer_score >= player_score)
      puts 'Dealer wins!'
    elsif dealer_score > 21 || (player_score <= 21 && player_score > dealer_score)
      puts 'You win!'
    elsif player_score == dealer_score
      puts 'Its a tie!'
      @player.add_to_bank(10)
      @dealer.add_to_bank(10)
    else
      puts 'No tie!'
    end
  end

  def update_player_bank
    player_score = @player.hand_value
    dealer_score = @dealer.hand_value

    if player_score > 21 || (dealer_score <= 21 && dealer_score >= player_score)
      @dealer.add_to_bank(20)
    elsif dealer_score > 21 || (player_score <= 21 && player_score > dealer_score)
      @player.add_to_bank(20)
    else
      @player.add_to_bank(10)
      @dealer.add_to_bank(10)
    end
  end

  def reset_game
    @deck = Deck.new
    @player.clear_hand
    @dealer.clear_hand
  end

  def play_again
    puts 'Want to play again? (1. Yes / 2. No)'
    choice = nil
    loop do
      choice = gets.chomp
      break if %w[1 2].include?(choice)

      puts 'Invalid choice. Please choose "1" for Yes or "2" for No.'
    end

    reset_game if choice == '1'
    choice == '1'
  end
end
