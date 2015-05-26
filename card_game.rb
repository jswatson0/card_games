# Global array for players
$players = []

class Card
  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(Spade Heart Club Diamond)

  attr_accessor :rank, :suit, :value

  def initialize(id)
    self.rank = RANKS[id % 13]
    self.suit = SUITS[id % 4]

    # ToDo: refactor kuz this seems ugly (maybe use a switch)
    if self.rank.to_i.between?(2,10)
      self.value = self.rank.to_i
    elsif self.rank == "A"
      self.value = 11
    else
      self.value = 10
    end

  end
end

class Deck
  attr_accessor :cards
  def initialize
    # shuffle array and init each Card
    self.cards = (0..51).to_a.shuffle.collect { |id| Card.new(id) }
    return false
  end

  def shuffle
    self.cards = self.cards.shuffle
  end
end

class Player
  attr_accessor :hand, :name, :hand_value
  def initialize(name)
    # super
    self.name = name
    self.hand = []
    self.hand_value = 0
  end
end

class Dealer
  attr_accessor :deck, :hand, :hand_value, :name

  def initialize
    self.deck = Deck.new
    self.hand = []
    self.name = "Bank"
    self.hand_value = 0
    $players << self
  end

  def shuffle_deck
    self.deck.shuffle
  end

  # The dealer initilizes a player
  def add_player(player_name)
    player = Player.new(player_name)
    $players << player
  end


  def deal_cards(player_name, num_cards)
    num_cards -= 1
    cards = self.deck.cards[0..num_cards]

    $players.each do |player|
      if player.name == player_name
        cards.each do |card|
          player.hand << card
          player.hand_value += card.value
          self.deck.cards.shift
        end
      end
    end

    # return cards
  end

  def check_hand(player_name)
    $players.each do |player|
      if player.name == player_name
        player.hand.each do |card|
          puts "#{card.rank}: #{card.suit}"
        end
        puts "Your hand has a value of #{player.hand_value}"
      end
    end
    return false
  end

  def show_table
    $players.each do |player|
      if player.name == 'Bank'
        puts "The bank is showing:"
        puts "#{player.hand.first.rank}: #{player.hand.first.suit}"
      else
        puts "#{player.name} is showing:"
        $dealer.check_hand(player.name)
      end

    end
  end

  def hit_stay(player_name)
    $players.each do |player|
      if player.name == player_name
        puts "#{player.name}, this is your hand:"
        self.check_hand(player_name)
        puts "Would you like to hit or stay? [hit/stay]"
        res = gets.chomp
        while res == 'hit'
          self.deal_cards(player_name, 1)
          puts "#{player.name}, this is your hand:"
          puts "#{self.check_hand(player_name)}"
          puts "Would you like to hit or stay? [hit/stay]"
          res = gets.chomp
        end
      end
    end
  end

  def declare_winner

  end
end

class Blackjack
  def initialize
    self.dealer = $dealer
    self.players = $players
  end
end


# binding.pry

$dealer = Dealer.new

puts "Hello! Welcome to the table, my name is Frank."

puts "What should I call you?"
player1 = gets.chomp
$dealer.add_player(player1)

# puts "Who else is joining you for this game?"
# player2 = gets.chomp
# $dealer.add_player(player2)

puts "What game are we playing?"
game = gets.chomp
if game == "blackjack"
  $dealer.shuffle_deck
  $dealer.deal_cards(player1, 2)
  # $dealer.deal_card(player2, 2)
  $dealer.deal_cards('Bank', 2)
  $dealer.show_table
end

$dealer.hit_stay(player1)
$dealer.hit_stay('Bank')






