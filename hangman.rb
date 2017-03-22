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

	
end
