# Sam's Tic Tac Toe solution!


def welcome
	# started with a simple method to print a little intro + instructions. This code only runs the very first time a game is started.
	# (i.e. I don't want to call this method again if the players finish a game and decide to play another round).
	puts "\nWelcome to Tic Tac Toe. You know the rules.."
	puts "Just type a number on the grid to make your move when prompted!"
	puts "May the odds ever be in your favor..."
end

# for class Game, I wanted to set up an overarching class that would contain all methods and actually encompass my Player class as well. 
# I was having trouble accessing certain things doing separate classes outside of each other, but in retrospect I guess I could have used 
# an overarching module, or used class inheritance but I didn't feel like I understood that well enough to use it (yet).

class Game
	# start with initialize method for the game object 
	def initialize

		# initialized two players with two arguments, name and letter. I could randomize the letter but decided it didn't matter,
		# and to just have player 1 always be 'x' and player 2 always be 'o'. i set the name argument to nil so players could type their
		# own names later.

		@player1 = Player.new(nil, "x")
		@player2 = Player.new(nil, "o")

		# made an array of every winning combination to check if any of these have filled up with x's or o's 
		# every time a new move is made. Not 100% sure if this is the best place to put my winning combos array 
		# but it logically made sense to me (and worked). the items in each array are the keys from the board hash.

		@winning_combos = [
			["a1", "a2", "a3"],
			["b1", "b2", "b3"],
			["c1", "c2", "c3"],
			["a1", "b1", "c1"],
			["a2", "b2", "c2"],
			["a3", "b3", "c3"],
			["a1", "b2", "c3"],
			["a3", "b2", "c1"]
		]

		# used a hash to create the board, which is how we'll get our input and replace the spaces on the board with player markers.

		@board = { 
			"a1" => 1,
			"a2" => 2,
			"a3" => 3,
			"b1" => 4,
			"b2" => 5,
			"b3" => 6,
			"c1" => 7,
			"c2" => 8,
			"c3" => 9
		}

		# set a variable called @move_count here - this was how i ultimately kept track of whether a tie had occurred.

		@move_count = 1
	end

	# class Player to refer back to the creation of player objects within the Game class initialize method. 
	# I wasn't sure if it's cool to have a class within a class generally speaking, but as in other places I went with what worked.
	# I also took care of set and get methods by including attr_accessor for name and letter.
	
	class Player
		attr_accessor :name, :letter
		def initialize(name, letter)
			@name = name
			@letter = letter
		end
	end

	# gameplay method that contains a simple loop containing several other methods that are defined
	# elsewhere and keep the game running. I also included my variable of move_count which goes up every time 
	# the loop runs i.e. a valid move has been entered and no one has won or tied.

	def gameplay
		player_names
		loop do
			@move_count += 1 
			display_board
			make_your_move
			check_winning_combos
			switch_player
		end
	end

	# simple method to get the players' names and to randomly determine who goes first by calling .sample on an array containing both players.
	# this also sets the @current_player variable which is important for proper turn switching.

	def player_names
		puts "\nPlayer 1, please enter your name. You'll be X:"
		@player1.name = gets.chomp
		puts "\nHi #{@player1.name}!"
		puts "\nPlayer 2, please enter your name. You'll be O:"
		@player2.name = gets.chomp
		puts "\nHi #{@player2.name}!"
		players_array = [@player1, @player2]
		@current_player = players_array.sample
		puts "\n#{@current_player.name}, you've been randomly chosen to start."	
	end

	# the high-tech graphics of my game. I indexed the hash with its keys to put the corresponding number values on the board.
	# the numbers on the board then make it easy for the players to see what to type for their next move.

	def display_board
		puts ""
		puts "#{@board["a1"]}|#{@board["a2"]}|#{@board["a3"]}"
		puts "-----"
		puts "#{@board["b1"]}|#{@board["b2"]}|#{@board["b3"]}"
		puts "-----"
		puts "#{@board["c1"]}|#{@board["c2"]}|#{@board["c3"]}"
	end

	# the last and possibly most important of gameplay - getting input for the players' moves. I was stuck for a while on how to 
	# reject a move if the space has already been taken (figured it out on lines 141-143). not sure if this was the most elegant 
	# way to do it but it worked!

	def make_your_move
		# also wasn't sure if it's normal to put ifs within ifs 
		if @move_count < 11
			puts ""
			puts "#{@current_player.name}, please enter your move (#{@current_player.letter}):"
			move = gets.chomp.to_i
			if !(@board.has_value?(move))
				puts "Sorry, that space has already been taken."
				@move_count - 1
				make_your_move
				# these below lines change the value of the board hash based on which condition is fulfilled (what integer was typed as the move).
				# the way I coded this seems to violate DRY, but I wasn't really sure of a better way to automate this.
				elsif move == 1
					@board["a1"] = @current_player.letter
				elsif move == 2
					@board["a2"] = @current_player.letter
				elsif move == 3
					@board["a3"] = @current_player.letter
				elsif move == 4
					@board["b1"] = @current_player.letter
				elsif move == 5
					@board["b2"] = @current_player.letter
				elsif move == 6
					@board["b3"] = @current_player.letter
				elsif move == 7
					@board["c1"] = @current_player.letter
				elsif move == 8
					@board["c2"] = @current_player.letter
				elsif move == 9
					@board["c3"] = @current_player.letter
			else
				puts "That is not a valid move."
				@move_count - 1
				display_board
				make_your_move
			end
		else
			puts "Looks like it's a tie. Play again? (y/n):"
			start_over
		end
	end

	# this is my favorite method that I wrote! I needed to iterate on an array within an array to check for winning combos. If any of the arrays
	# came back with all 3 values having been changed to a player's letter, then it would trigger victory for that player. this method gets called
	# after every move and only triggers the winner message if the condition is met.

	def check_winning_combos
		@winning_combos.each do |x|
				if x.all? { |a| @board[a] == @current_player.letter }
					@winner = @current_player.name
					display_board
					puts "#{@winner} has won!"
					puts "Would you like to play again? (y/n):"
					start_over
			end
		end
	end

	# this just switches the player depending on who just went. @current_player is set initially in player_names method
	# using a random selection from an array containing both players.

	def switch_player
		if @current_player == @player1
			@current_player = @player2
		elsif @current_player == @player2
			@current_player = @player1
		else
			nil
		end
	end

	# this method handles when a game has ended and starts a new game with a clean board if the player answers 'y'
	# and exits the program if they respond 'n'.

	def start_over
		answer = gets.chomp.to_s
		if answer == "y"
			y = Game.new
			y.gameplay
			elsif answer == "n"
				puts "Ok, until next time!"
				exit
			else
				puts "Sorry, not a valid response"
				start_over
		end
	end
end

# welcome method for instructions, then initialize game object, 
# then call gameplay method on the brand new game object, and we're off!

welcome
g = Game.new
g.gameplay



