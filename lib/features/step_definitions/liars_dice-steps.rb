require 'rspec/mocks/standalone'
require_relative "../../liars_dice.rb"

Given /^I start a new game$/ do
  @game = LiarsDice.new
end

When /^I enter my name as (\w+)$/ do |name|
  @game.player = name
end

Then /^the computer welcomes me to the game with "(.*?)"$/ do |arg1|
  @game.welcome_player.should eq arg1
end

Then /^randomly chooses who goes first$/ do
  [@game.player, "Computer"].should include @game.current_player
end

Then /^rolls five random dice for each player$/ do
  (@game.dice[:player] + @game.dice[:computer]).length.should eq 10
end

Given /^I have a started a game$/ do
  @game = LiarsDice.new(:player)
  @game.player = "Chris"
end

Given /^it is my turn$/ do
  @game.current_player.should eq "Chris"
end

Given /^the computer knows my name is Chris/ do
  @game.player.should eq "Chris"
end

Then /^the computer prints "(.*?)"$/ do |arg1|
  @game.should_receive(:puts).with(arg1)
  @game.indicate_player_turn
end

Then /^waits for my input of "(.*?)"$/ do |arg1|
  @game.should_receive(:gets).and_return(arg1)
  @game.get_player_move
end

Given /^it is the computer's turn$/ do
  @game = LiarsDice.new(:computer)
  @game.current_player.should eq "Computer"
end

Then /^the computer randomly chooses an open position for its move$/ do
  open_spots = @game.open_spots
  @com_move = @game.computer_move
  open_spots.should include(@com_move)
end

Given /^the computer is playing X$/ do
  @game.computer_symbol.should eq :X
end

Then /^the board should have an X on it$/ do
  @game.current_state.should include 'X'
end

Then /^the (.*?) bet should now be (.*?)$/ do |arg1, arg2|
  @game.current_bet[arg1.to_sym].should eq arg2
end

When /^I enter a bet of "(.*?)"/ do |arg1|
  @game.should_receive(:get_player_move).and_return(arg1)
end

When /^"(.*?)" is a legal bet/ do |arg1|
  @game.validate_player_move(arg1.split(" ")).should eq true
end

When /^the current bet is face (.*?), count (.*?)/ do |arg1, arg2|
  @game.current_bet[:face] = arg1
  @game.current_bet[:count] = arg2
end

When /^there are three twos/ do
  @game.dice[:player] = [1,2,3,4,5]
  @game.dice[:computer] = [1,2,2,3,4]
end

Then /^it is now the computer's turn$/ do
  @game.current_player.should eq "Computer"
end

When /^the over bet is successful$/ do
  @game.dice_remaining[:computer].should eq 4
end

Then /^I am declared the winner$/ do
  @game.determine_winner
  @game.player_won?.should be_true
end

Then /^the game ends$/ do
  @game.over?.should be_true
end

Given /^there are not three symbols in a row$/ do
  @game.board = {
      :A1 => :X, :A2 => :O, :A3 => :X,
      :B1 => :X, :B2 => :O, :B3 => :X,
      :C1 => :O, :C2 => :X, :C3 => :O
    }
    @game.determine_winner
end

When /^there are no open spaces left on the board$/ do
  @game.spots_open?.should be_false
end

Then /^the game is declared a draw$/ do
  @game.draw?.should be_true
end

When /^"(.*?)" is taken$/ do |arg1|
  @game.board[arg1.to_sym] = :O
  @taken_spot = arg1.to_sym
end

Then /^computer should ask me for another position "(.*?)"$/ do |arg1|
  @game.board[arg1.to_sym] = ' '
  @game.should_receive(:get_player_move).twice.and_return(@taken_spot, arg1)
  @game.player_move.should eq arg1.to_sym
end
