Feature: Tic-Tac-Toe Game
	As a Ruby student I need a final project
	In order to pass the class
	I would like to play the computer at Liars Dice

Scenario: Start Game
	Given I start a new Liar's Dice game
	When I enter my name as Chris
	Then the computer welcomes me to the game with "Hello, Chris!"
		And randomly chooses who goes first

Scenario: My Turn
	Given I have a started a Liar's Dice game
		And it is my turn
		And the computer knows my name is Renee
	Then the computer prints "Renee's Move:"
		And waits for my input of "B2"

Scenario: Computer's Turn
	Given I have a started Tic-Tac-Toe game
		And it is the computer's turn
		And the computer is playing X
	Then the computer randomly chooses an open position for its move 
		And the board should have an X on it

Scenario: Making Moves
	Given I have a started Tic-Tac-Toe game
		And it is my turn
		And I am playing X
	When I enter a position "A1" on the board
		And "A1" is not taken
	Then the board should have an X on it
		And it is now the computer's turn

Scenario: Making Bad Moves
	Given I have a started Tic-Tac-Toe game
		And it is my turn
		And I am playing X
	When I enter a position "A1" on the board
		And "A1" is taken
	Then computer should ask me for another position "B2"
		And it is now the computer's turn

Scenario: Winning the Game
	Given I have a started Tic-Tac-Toe game
		And I am playing X
	When there are three X's in a row
	Then I am declared the winner
		And the game ends

Scenario: Game is a draw
	Given I have a started Tic-Tac-Toe game
		And there are not three symbols in a row
	When there are no open spaces left on the board
	Then the game is declared a draw 
		And the game ends
