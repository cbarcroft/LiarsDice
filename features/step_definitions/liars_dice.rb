class LiarsDice
  attr_reader :player_dice_remaining, :player_move, :computer_won, :player_won, :over
  attr_accessor :board, :current_state
  
  COMMANDS = ["Face", "Count", "Over", "SpotOn"]
  
  def initialize( first_turn = false)
    @players = {:player => "Player", :computer => "Computer"}
    @current_player = first_turn
    if first_turn == false
      @current_player = [:computer, :player].sample
    end
    @waiting_player = [:computer, :player].select{|player| player != @current_player}
    @current_bet = {:face => 1, :count => 1}
    @dice = {:player => [], :computer => []}
    @dice_remaining = {:player => 5, :computer => 5}
    @computer_won = false
    @player_won = false
    @over = false
  end
  
  def current_player
    @players[@current_player]
  end
  
  def player=(str)
    @players[:player] = str
  end
  
  def player
    @players[:player]
  end
  
  def welcome_player
    "Welcome, #{@players[:player]}!"
  end
  
  def indicate_player_turn
    puts "#{@players[@current_player]}'s turn:"
  end
  
  def get_player_move
    gets.chomp
  end
  
  def player_move
    move = self.get_player_move.split(" ")
    until (self.validate_player_move(move))
      move = self.get_player_move.split(" ")
    end
    
    case move[0].upcase
    when "FACE"
      puts "You have raised the face value to #{move[1]}"
      @current_bet[:face] = move[1]
    when "COUNT"
      puts "You have raised the count to #{move[1]}"
      @current_bet[:count] = move[1]
    when "SPOTON"
      puts "You think the bet is spot on."
      self.check_spoton
    when "OVER"
      puts "You think the computer's bet is too high."
      self.check_over
    end
  end
  
  def computer_move
    puts "Computer's Turn:"
    sleep(1)
  end
  
  def validate_player_move(move)
    valid = true
    if !COMMANDS.include? parsed_move[0]
      puts "Unrecognized command"
      valid = false
    end
  end
  
  def check_spoton
    totals = get_dice_totals
    if totals[@current_bet[:face]] == @current_bet.count
      puts "#{@players[@current_player]} is correct! #{@players[@waiting_player]} loses one die!"
      @dice_remaining[@waiting_player] -= 1
    else
      puts "#{@players[@current_player]} is wrong, and loses one die! "
      @dice_remaining[@current_player] -= 1
    end
  end
  
  def check_over
    
  end
  
  def get_dice_totals
    (@player_dice << @computer_dice).flatten.each do |die|
      totals[die] += 1
    end
    totals
  end
  
  def dice_remaining?
    @
  end
  
  def computer_dice_remaining?
  end
  
  def draw?
   (!self.spots_open? && !@player_won && !computer_won) ? true : false
  end
  
  def over?
    (self.draw? || @player_won || @computer_won)? true : false
  end
  
  def player_won?
    @player_won? true : false
  end
  
  def computer_won?
    @computer_won? true : false
  end
  
  def determine_winner

    @over = self.over?
  end
end
