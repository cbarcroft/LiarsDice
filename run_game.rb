require './features/step_definitions/liars_dice.rb'

@game = LiarsDice.new
puts @game.welcome_player

until @game.over?
	case @game.current_player
	when "Computer"
		@game.computer_move
	when @game.player
		@game.indicate_player_turn
		@game.player_move
	end
	@game.current_state
	@game.determine_winner
end

puts "You win!" if @game.player_won?
puts "Computer wins!" if @game.computer_won?
