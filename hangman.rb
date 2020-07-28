require 'random-word'

class Hangman
	ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")

	def initialize
		@word = RandomWord.nouns(not_longer_than: 10).next.upcase.split("")
		@max_guesses = 7
		@guessed_letters = []
		@correctly_guessed_letters = []
		puts "The word has been chosen.\nTo guess, type a letter or a word you think is the answer.\nYou have #{@max_guesses} guesses. GO!"
		resolve
	end

	def guess_letter(letter)
		printf "\033[2J"
		if @guessed_letters.include? letter.upcase
			puts "You already guessed the letter #{letter.upcase}. Try guessing another letter."
		elsif  !ALPHABET.include? @new_guess
			puts "Please only use letters of English alphabet. No other characters supported." 
		elsif @word.include? letter.upcase 
			@guessed_letters << letter.upcase
			@correctly_guessed_letters << letter.upcase
			puts "Great job!"
		else
			@max_guesses -=1
			@guessed_letters << letter.upcase
			puts "Oops, there's no letter #{letter.upcase} in this word."
		end
		resolve
	end

	def guess_answer(answer)
		printf "\033[2J"
		@answer = answer.upcase.split("")
		if @answer == @word
			@answer.each {|i| @correctly_guessed_letters << i.to_s}
		elsif @answer.any? {|i| !ALPHABET.include? i }
			puts "Please only use letters of English alphabet. No other characters supported." 
		else 
			@max_guesses -=1
			puts "Oh, no! That's not the right word!" if @max_guesses > 0
		end
		resolve
	end

	def resolve
		draw_hangman(@max_guesses)
		print_word
		if @max_guesses == 0 
			puts "GAME OVER!\nThe correct answer was '#{@word.join}'."
		elsif @correctly_guessed_letters.uniq.sort == @word.uniq.sort
			puts "YEEEY, YOU WON!"
		else
			prompt_player
		end
	end

	def print_word
		puts
		@word.each { |i| print (@correctly_guessed_letters.include? i.to_s) ? "#{i.to_s} " : "_ " }
		puts "\n\n"
	end

	def prompt_player
		puts "What's your next guess?"
		@new_guess = gets.chomp.upcase.to_s
		if @new_guess.length == 0
			puts "You didn't type anything. Try typing a letter, or a word if you know the answer."
			prompt_player	
		elsif	@new_guess.length == 1
			guess_letter(@new_guess)
		else
			guess_answer(@new_guess)
		end
	end

	def draw_hangman(guesses_left)
		case guesses_left
		when 6
			puts "\n\n\n\n\n_____________"
		when 5
			5.times {puts "      |"}
			puts "______|______"
		when 4
			puts " _____"
			5.times {puts "      |"}
			puts "______|______"
		when 3
			puts " _____"
			puts "|     |"
			4.times {puts "      |"}
			puts "______|______"
		when 2
			puts" _____"
			puts "|     |"
			puts "Q     |"
			3.times {puts "      |"}
			puts "______|______"
		when 1
			puts " _____"
			puts "|     |"
			puts "Q     |"
			puts "/\\    |"
			2.times {puts "      |"}
			puts "______|______"
		when 0
			puts " _____"
			puts "|     |"
			puts "Q     |"
			puts "/\\    |"
			puts "||    |"
			puts "      |"
			puts "______|______"
		end
	end
end

Hangman.new