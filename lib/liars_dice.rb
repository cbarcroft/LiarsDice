class LiarsDice
  attr_reader :player_move, :computer_won, :player_won, :over, :current_bet, :waiting_player
  attr_accessor :current_state, :dice, :dice_remaining
  
  COMMANDS = ["FACE", "COUNT", "OVER", "SPOTON"]
  
  def initialize( first_turn = false)
    system("clear")
    @players = {:player => "Player", :computer => "Computer"}
    @current_player = first_turn
    if first_turn == false
      @current_player = [:computer, :player].sample
    end
    @waiting_player = [:computer, :player].select{|player| player != @current_player}[0]
    @current_bet = {:face => 1, :count => 1}
    @dice = {:player => [], :computer => []}
    @dice_remaining = {:player => 5, :computer => 5}
    @computer_won = false
    @player_won = false
    @over = false
    self.roll_dice
        self.current_state
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
  
  def switch_turns
    temp = @current_player
    @current_player = @waiting_player
    @waiting_player = temp
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
    self.switch_turns
  end
  
  def computer_move
    puts "Computer's Turn:"
    sleep(1)
    move = self.smart_select.split(" ")
    
    case move[0]
    when "FACE"
      puts "Computer has raised the face value to #{move[1]}"
      @current_bet[:face] = move[1]
    when "COUNT"
      puts "Computer has raised the count to #{move[1]}"
      @current_bet[:count] = move[1]
    when "SPOTON"
      puts "Computer thinks the bet is spot on."
      self.check_spoton
    when "OVER"
      puts "Computer challenges your bet."
      self.check_over
    end
    self.switch_turns
  end
  
  def smart_select
    comp_dice = self.get_dice_total
    if comp_dice[@current_bet[:face].to_i] == @current_bet[:count] then #if computer has the current bet showing in its own dice
      if @dice_remaining[:player] <= 2 then #and the player has two or less dice of their own
        return "SPOTON"
      else
        return "COUNT #{@current_bet[:count].to_i + 1}" #increment count by one
      end
    elsif (comp_dice[@current_bet[:face].to_i]).to_i < @current_bet[:count].to_i then #if computer has less dice of the current face than the bet
        if (@current_bet[:count].to_i - comp_dice[@current_bet[:face].to_i].to_i) >= 2 then
          return "OVER"
        else
          return "COUNT #{@current_bet[:count].to_i + 1}"
        end
    elsif comp_dice[@current_bet[:face].to_i].to_i > @current_bet[:count].to_i then #if computer has more dice of the current face than the bet
        if (comp_dice[@current_bet[:face].to_i].to_i - @current_bet[:count].to_i) >= 2 then
          return "COUNT #{@current_bet[:count].to_i + 2}"
        else
          return "COUNT #{@current_bet[:count].to_i + 1}"
        end
    else
      return "OVER" #default bet, but this should never happen
    end
  end
  
  def validate_player_move(move)
    valid = true
    if !COMMANDS.include? move[0].upcase
      puts "Unrecognized command #{move[0].upcase}"
      valid = false
    end
    if move[0].upcase == "FACE" then
      if move[1] == nil || move[1].to_i < 1 || move[1].to_i > 6 then
        puts "Invalid value(#{move[1]}) for FACE"
        valid = false
      elsif !(move[1].to_i > @current_bet[:face].to_i)
        puts "Face bet must be higher than the current bet: #{@current_bet[:face]}"
        valid = false
      end
    end
    if move[0].upcase == "COUNT" then
      if move[1].to_i == nil || move[1].to_i < 1 || move[1].to_i > 10 then
        puts "Invalid value(#{move[1]}) for FACE"
        valid = false
      elsif !(move[1].to_i > @current_bet[:count].to_i)
        puts "Count bet must be higher than the current bet: #{@current_bet[:count]}"
        valid = false
      end
    end
    valid
  end
  
  def roll_dice
    @players.each do |player, name|
      @dice[player] = []
      @dice[player] = @dice_remaining[player].times.map{ rand(1..6) } 
    end
  end
  
  def check_spoton
    puts self.print_dice(true)
    totals = get_dice_totals
    if totals[@current_bet[:face].to_i] == @current_bet[:count]
      puts "#{@players[@current_player]} is correct! #{@players[@waiting_player]} loses one die!"
      @dice_remaining[@waiting_player] -= 1
    else
      puts "#{@players[@current_player]} is wrong, and loses one die! "
      @dice_remaining[@current_player] -= 1
    end
    
    self.reset
  end
  
  def check_over
    puts self.print_dice(true)
    totals = get_dice_totals
    if totals[@current_bet[:face].to_i].to_i < @current_bet[:count].to_i
      puts "#{@players[@current_player]} is correct! #{@players[@waiting_player]} loses one die!"
      @dice_remaining[@waiting_player] -= 1
    else
      puts "#{@players[@current_player]} is wrong, and loses one die! "
      @dice_remaining[@current_player] -= 1
    end
    
    self.reset
  end
  
  def reset
    self.roll_dice
    @current_bet[:face] = 1
    @current_bet[:count] = 1
  end
  
  def get_dice_totals
    totals = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0} 
    (@dice[:player] + @dice[:computer]).flatten.each do |die|
      totals[die] += 1
    end
    totals
  end
  
  def get_dice_total
    totals = {1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0} 
    @dice[:computer].each do |die|
      totals[die] += 1
    end
    totals
  end
  
  def current_state
    puts "Current Bet: Face => #{@current_bet[:face]}   Count => #{@current_bet[:count]}"
    puts self.print_dice
  end
  
  def print_dice(show_computer = false)
    @dice[:player].each do |die|
      print "|#{die}| "
    end
    print "   ************   "
    if show_computer then
      @dice[:computer].each do |die|
        print "|#{die}| "
      end
    else
      @dice[:computer].each do |die|
        print "|X| "
      end
    end
    print "\n"
  end
  
  def dice_remaining?
    @dice_remaining[:player].to_i > 0 ? true : false
  end
  
  def computer_dice_remaining?
    @dice_remaining[:computer].to_i > 0 ? true : false
  end
  
  def over?
    (self.player_won? || self.computer_won?)? true : false
  end
  
  def player_won?
    self.computer_dice_remaining? ? false : true
  end
  
  def computer_won?
    self.dice_remaining? ? false : true
  end
  
  def determine_winner
    @over = self.over?
  end
end
