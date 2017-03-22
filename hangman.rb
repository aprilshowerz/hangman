require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

get "/" do
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

		secret_word=""

		while (secret_word.size<5 || secret_word.size>12) do
		dictionary=File.readlines "5desk.txt"
		dictionary.map! {|i| i.downcase.chomp!}
		secret_word=dictionary[rand(dictionary.size)]
		end
		@secret_word=secret_word
		session[:secret_word]=@secret_word.upcase
		session[:guessed]=[]
		session[:incorrect_guesses]=0
		session[:win]=false
		session[:lose]=false
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
