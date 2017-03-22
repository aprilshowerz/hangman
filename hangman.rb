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


end
