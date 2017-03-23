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

		if (params["guess"].size!=1 || params["guess"]>'z' || params["guess"]<'A' || (session[:guessed].include? (params["guess"].upcase)))
			@message="Invalid input"

		else
			session[:guessed]<<params["guess"].upcase
			if !session[:secret_word].include? params["guess"].upcase
				session[:incorrect_guesses]+=1
			else
				secret_array=session[:secret_word].split(//)
				secret_array.size.times do |i|
					if secret_array[i]==params["guess"].upcase
						session[:partial_word][i]=secret_array[i]
					end
				end
			end
		end
	end

	def update
		@guessed=session[:guessed]
		@incorrect_guesses=session[:incorrect_guesses]
		@win=session[:win]
		@lose=session[:lose]
		@partial_word=session[:partial_word]


		if @win
			@message= "Congratulations, you won! <br>Play again?"
		end
		if @lose
			@message= "GG, you lose. The secret word was #{session[:secret_word]} <br>Play again?"
		end

		if @win || @lose
			session[:secret_word]=nil
		end
	end

	def game_over?
		if session[:incorrect_guesses]>5
			session[:lose]=true
		
		else
			session[:win]=true
			session[:secret_word].each_char do |i|
				if !session[:guessed].include? i
					session[:win]=false
				end
			end
		end

	end

end
