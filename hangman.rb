require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

get "/" do
	# starts a new game if the secret_word is nil for this session.
	if session[:secret_word]==nil
		new_game
	end
	update
	erb :index
end

post "/" do
	verify_guess
	game_over?
	update
	erb :index
end

helpers do

	def new_game

		# makes secret_word blank.
		secret_word=""

		# if secret_word is less than 5 or greater than 12 run this loop.
		while (secret_word.size<5 || secret_word.size>12) do
		#reads the lines of the 5desk.txt file and sets them equal to dictionary.
		dictionary=File.readlines "5desk.txt"
		#getting each line of dictionary, changing them to lowercase and iterating through them.
		dictionary.map! {|i| i.downcase.chomp!}
		#sets secret_word equal to a random choice from the dictionary? study this line more.
		secret_word=dictionary[rand(dictionary.size)]
		end
		# makes secret_word accessible to other views. Makes it a global variable by using @.
		@secret_word=secret_word
		#sets the session variables to pass values through to other views. 
		#secret_word is set to the global variable secret_word (which is an empty string) and set to uppercase.
		session[:secret_word]=@secret_word.upcase
		#sets guessed to an empty variable.
		session[:guessed]=[]
		#sets incorrect_guesses to zero so you start fresh with a clean slate for the new game.
		session[:incorrect_guesses]=0
		#sets win to false, because you haven't won yet.
		session[:win]=false
		#sets lose to false, because you haven't lost yet.
		session[:lose]=false
		#sets partial_word to and underscore and multiplies it by the secret word size. This displays
		# the correct amount of underscores.
		session[:partial_word]="_"*@secret_word.size
	end

	def verify_guess
		#if guess size changes to 1 or guess is greater than(comes after?) Z or lower than(comes before?) A or if the guess is a letter that has been guessed already (guessed).
		if (params["guess"].size!=1 || params["guess"]>'z' || params["guess"]<'A' || (session[:guessed].include? (params["guess"].upcase)))
			#sets message to Invalid input.
			@message="Invalid input"

		else
			#adds guess to the guessed array and makes it uppercase.
			session[:guessed]<<params["guess"].upcase
			# if secret_word does not include the guess (and makes it upcase)
			if !session[:secret_word].include? params["guess"].upcase
				#increment the incorrect_guesses value by 1.
				session[:incorrect_guesses]+=1
			else
				#splits the secret_word into an array called secret_array.
				secret_array=session[:secret_word].split(//)
				#iterates over secred_array for each position.
				secret_array.size.times do |i|
					#if any of the iterations of the secret array are equal to the guess (makes it upcase too)
					if secret_array[i]==params["guess"].upcase
						#set partial_word equal to that secret_array iteration value.
						session[:partial_word][i]=secret_array[i]
					end
				end
			end
		end
	end

	def update
		#sets guessed as a global variable.
		@guessed=session[:guessed]
		#sets incorrect_guesses as a global variable.
		@incorrect_guesses=session[:incorrect_guesses]
		#sets win as a global variable.
		@win=session[:win]
		#sets lose as a global variable.
		@lose=session[:lose]
		#sets partial_word as a global variable
		@partial_word=session[:partial_word]


		if @win
			#winning message.
			@message= "Congratulations, you won! <br>Play again?"
		end
		if @lose
			#losing message.
			@message= "You're a loser! The secret word was #{session[:secret_word]} <br>Wanna try to redeem yourself?"
		end
		#if win or lose, reset the secret_word to a nil state.
		if @win || @lose
			session[:secret_word]=nil
		end
	end

	def game_over?
		#if incorrect_guesses is greateer than 5....
		if session[:incorrect_guesses]>5
			#set lose to true.
			session[:lose]=true
		
		else
			#set win to true.
			session[:win]=true
			#iterate over each character of secret_word.
			session[:secret_word].each_char do |i|
				#if guessed does not include one of those characters....
				if !session[:guessed].include? i
					#set win to false.
					session[:win]=false
				end
			end
		end

	end

end
