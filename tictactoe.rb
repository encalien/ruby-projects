require 'pry'

class Tictactoe
	def initialize(grid_size = 3)
		@grid_size = grid_size
		@grid_sqr = grid_size ** 2
		@possible_positions = (1..@grid_sqr).to_a
		@occupied_positions = Hash[(@possible_positions).map {|x| [x, x.to_s.rjust(3, " ")]}]
		@player_starts = [true, false].sample
		@game_over = false

		start_game
	end

	def start_game
		puts "Welcome to Tic Tac Toe"
		puts @player_starts ? "You control X. You go first." : "You control O. The AI goes first."
		puts "Press 'Enter' to start the game."
		@players_turn = !@player_starts
		next_turn if gets == "\n"
	end

	def next_turn
		draw_grid
		@players_turn = !@players_turn
		end_game
	end

	def player_chooses
		puts "Where would you like to place your sign? Possible positions are: #{@possible_positions}."
		players_placement = gets.chomp.to_i
		if	@possible_positions.include? players_placement
			@occupied_positions[players_placement] = @player_starts ? "X" : "O"
			@possible_positions.delete(players_placement)
			set_winner("player")
			next_turn
		else
			puts "'Please choose a valid option."
			player_chooses
		end
	end

	def ai_chooses
		ai_placement = 1 + rand(9)
		if @possible_positions.include? ai_placement
			@occupied_positions[ai_placement] = @player_starts ? "O" : "X"
			@possible_positions.delete(ai_placement)
			set_winner("AI")
			next_turn
		else 
			ai_chooses
		end
	end
		
	def draw_grid
		printf "\033[2J"
		grid_multiples = (1..@grid_size).map {|i| i * @grid_size}

		@occupied_positions.each do |key, value| 
			if grid_multiples.include? key
				if value == "X" || value == "O"
					puts " " + value + " "
				else
					puts value
				end
			else
				if value == "X" || value == "O"
					print " " + value + " |"
				else
					print value + "|"
				end
			end
		end
		puts
	end

	def end_game
		if @ai_won
			puts "GAME OVER! You lost."
		elsif @player_won
			puts "CONGRATULATIONS! You won."
		else
			if @possible_positions == []
				puts "GAME OVER! It's a draw."
			else
				@players_turn ? player_chooses : ai_chooses
			end
		end
	end

	def set_winner(who)
		@xes = @occupied_positions.select {|key, value| value == "X"}
		@oes = @occupied_positions.select {|key, value| value == "O"}
		@hits = @player_starts ? @xes : @oes
		@winner = false

		case who 
		when "player"
			@hits = @player_starts ? @xes : @oes
			find_vertical
			find_horizontal
			find_diagonal
			@player_won = @winner
		when "AI" 
			@hits = !@player_starts ? @xes : @oes
			find_vertical
			find_horizontal
			find_diagonal
			@ai_won = @winner
		end
	end
		#	0*g+1  0*g+2   0*g+g
		#	1*g+1  1*g+2   1*g+g
		#	2*g+1  2*g+2 g-1*g+g

	def find_vertical

		# (x * g) + y    where y = (1...g), x = (0...g-1)

		@grid_size.times do |y|
			@winner = true if
				(0..(@grid_size-1)).each do |x|
					vertical_hit = x * @grid_size + y + 1
					if !@hits.include? vertical_hit
						break
					end
				end
			end
	end

	def find_horizontal

		# (x * (g + y)   where y = (1...g), x = (0...g-1)

		@grid_size.times do |x|
			@winner = true if
				(1..@grid_size).each do |y|
					horizontal_hit = x * @grid_size + y
					if !@hits.include? horizontal_hit
						break
					end
				end
			end
	end

	def find_diagonal

		# x * g + y where y = (1...g), x = (0...g-1)
		# x * g - x + g where y = (1...g), x = (0...g-1)

		@winner = true if
			catch :nowinner do
				@grid_size.times do |x|
					diagonal_hit = x * @grid_size + x + 1
					if !@hits.include? diagonal_hit
						throw :nowinner
					end
				end
			end
			
		@winner = true if
			catch :nowinner do
				@grid_size.times do |x|
					diagonal_hit = (x * @grid_size) - x + @grid_size
					if !@hits.include? diagonal_hit
						throw :nowinner
					end
				end
			end
	end
end

Tictactoe.new(3)
