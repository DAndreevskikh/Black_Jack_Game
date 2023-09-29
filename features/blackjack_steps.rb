require_relative '/home/dmitry/Black_Jack_Game/card'
require_relative '/home/dmitry/Black_Jack_Game/deck'
require_relative '/home/dmitry/Black_Jack_Game/player'

class Game
  attr_reader :player, :dealer

  def initialize(player_name, player_bank, dealer_bank)
    @deck = Deck.new
    @player = Player.new(player_name, player_bank)
    @dealer = Player.new('Дилер', dealer_bank)
    @current_hand_in_progress = false
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

  def player_skip_turn
    @current_hand_in_progress = false
  end

  def player_add_card
    if @player.hand.length == 2 && @current_hand_in_progress
      @player.add_to_hand(@deck.draw)
      @current_hand_in_progress = false if @player.hand_value >= 21
    end
  end

  def current_hand_in_progress?
    @current_hand_in_progress
  end

  private

  def check_player_win
    return unless @player.hand_value <= 21 && (@dealer.hand_value > 21 || @player.hand_value > @dealer.hand_value)

    puts 'Вы выиграли!'
    @player.add_to_bank(20)
    @dealer.deduct_from_bank(20)
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

  def player_turn
    @current_hand_in_progress = true

    loop do
      choice = get_player_choice

      case choice
      when 'пропустить'
        break
      when 'добавить карту'
        player_add_card
      when 'открыть карты'
        break
      else
        puts 'Неверный выбор. Пожалуйста, выберите "пропустить", "добавить карту" или "открыть карты".'
      end
    end

    @current_hand_in_progress = false
  end

  def get_player_choice
    puts 'Выберите действие:'
    puts '1. Пропустить'
    puts '2. Добавить карту' if @player.hand.length == 2
    puts '3. Открыть карты'

    choice = nil
    loop do
      choice = gets.chomp
      break if ['1', '2', '3'].include?(choice)
      puts 'Неверный выбор. Пожалуйста, выберите "1" для Пропуска, "2" для Добавления карты, или "3" для Открытия карт.'
    end

    case choice
    when '1' then 'пропустить'
    when '2' then 'добавить карту'
    when '3' then 'открыть карты'
    end
  end

  def dealer_turn
    while @dealer.hand_value < 17
      card = @deck.draw
      if card.nil?
        puts 'В колоде больше нет карт!'
        break
      else
        @dealer.add_to_hand(card)
      end
    end
  end

  def end_game
    show_result
    update_player_bank
    reset_game
  end

  def show_result
    player_score = @player.hand_value
    dealer_score = @dealer.hand_value

    puts 'Результат:'
    puts "Ваша рука: #{hand_to_string(@player.hand)}"
    puts "Ваши очки: #{player_score}"
    puts 'Дилер:'
    puts hand_to_string(@dealer.hand)
    puts "Очки дилера: #{dealer_score}"

    if @player.bank.zero?
      puts 'У Игрока закончились деньги в банке. Пополните Банк и приходите снова.'
    elsif @dealer.bank.zero?
      puts 'Дилер пуст, Вы его обчистели. Удачно покутить.'
    elsif player_score > 21 || (dealer_score <= 21 && dealer_score >= player_score)
      puts 'Дилер выиграл!'
    elsif dealer_score > 21 || (player_score <= 21 && player_score > dealer_score)
      puts 'Вы выиграли!'
    else
      if player_score == dealer_score
      puts 'Ничья!'
    end
  end
end

  def update_player_bank
  player_score = @player.hand_value
  dealer_score = @dealer.hand_value

  if player_score > 21 || (dealer_score <= 21 && dealer_score > player_score)
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
    @current_hand_in_progress = false
  end

  def play_again
    puts 'Хотите сыграть еще раз? (1. Да / 2. Нет)'
    choice = nil
    loop do
      choice = gets.chomp
      break if ['1', '2'].include?(choice)
      puts 'Неверный выбор. Пожалуйста, выберите "1" для Да или "2" для Нет.'
    end

    reset_game if choice == '1'
    choice == '1'
  end

  def hand_to_string(hand)
    hand.compact.map { |card| "#{card.rank}#{card.suit}" }.join(', ')
  end
end


Given('a new game is started') do
  @game = Game.new('Player', 100, 100)
end

When('the player skips their turn') do
  @game.player_skip_turn
end

Then('the round should end without additional cards dealt') do
  expect(@game.current_hand_in_progress?).to be(false)
end

When('the player adds a card') do
  @game.player_add_card
end

When('the player adds another card') do
  @game.player_add_card
end

When('the player adds a third card') do
  @game.player_add_card
end

When('the player adds a fourth card') do
  @game.player_add_card
end

When('the player opens their cards') do
  @game.player_skip_turn
end

Then('the round should end') do
  expect(@game.current_hand_in_progress?).to be(false)
end

And('the dealer should win') do
  expect(@game.dealer.bank).to be > 100
end

When('the dealer adds a card') do
  @game.dealer.add_to_hand(@game.instance_variable_get(:@deck).draw)
end

And('the dealer opens their cards') do
  @game.player_skip_turn
end

Then('the round should end in a tie') do
  expect(@game.player.bank).to eq(100)
  expect(@game.dealer.bank).to eq(100)
end

And('the player should win') do
  expect(@game.player.bank).to be > 100
end

And("the player's bank should be greater than {int}") do |amount|
  expect(@game.player.bank).to be > amount
end
