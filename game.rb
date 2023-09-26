class Game
  def initialize
    @deck = Deck.new
    @player = Player.new(get_player_name, 100)
    @dealer = Player.new('Дилер', 100)
  end

  def start
    loop do
      deal_initial_cards
      take_bets
      player_turn
      dealer_turn
      end_game
      break unless play_again?
    end
  end

  private

  def get_player_name
    puts 'Введите ваше имя:'
    gets.chomp
  end

  def deal_initial_cards
    2.times do
      @player.add_to_hand(@deck.draw)
      @dealer.add_to_hand(@deck.draw)
    end
  end

  def take_bets
    @player.bank -= 10
    @dealer.bank -= 10
  end

  def player_turn
    loop do
      show_game_status
      choice = get_player_choice

      case choice
      when 'пропустить'
        break
      when 'добавить карту'
        @player.add_to_hand(@deck.draw)
        break if @player.hand_value > 21
      when 'открыть карты'
        break
      else
        puts 'Неверный выбор. Пожалуйста, выберите "пропустить", "добавить карту" или "открыть карты".'
      end
    end
  end

  def show_game_status
    puts "Банк игрока: $#{@player.bank}"
    puts "Ваша рука: #{hand_to_string(@player.hand)}"
    puts "Очки: #{player.hand_value}"
    puts 'Дилер:'
    puts '*** ***'
  end

  def hand_to_string(hand)
    hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ')
  end

  def get_player_choice
    puts 'Выберите действие:'
    puts '1. Пропустить'
    puts '2. Добавить карту' if @player.hand.length == 2
    puts '3. Открыть карты'

    case gets.chomp
    when '1' then 'пропустить'
    when '2' then 'добавить карту'
    when '3' then 'открыть карты'
    else
      get_player_choice
    end
  end

  def dealer_turn
    while @dealer.hand_value < 17
      @dealer.add_to_hand(@deck.draw)
    end
  end

  def end_game
    show_result
    update_player_bank
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

    if player_score > 21 || (dealer_score <= 21 && dealer_score >= player_score)
      puts 'Дилер выиграл!'
    elsif dealer_score > 21 || (player_score <= 21 && player_score > dealer_score)
      puts 'Вы выиграли!'
    else
      puts 'Ничья!'
    end
  end

  def update_player_bank
    if @player.hand_value > 21 || (dealer.hand_value <= 21 && dealer.hand_value >= player.hand_value)
      @dealer.bank += 20
    elsif dealer.hand_value > 21 || (player.hand_value <= 21 && player.hand_value > dealer.hand_value)
      @player.bank += 20
    end
  end

  def play_again?
    puts 'Хотите сыграть еще раз? (да/нет)'
    gets.chomp.downcase == 'да'
  end
end
