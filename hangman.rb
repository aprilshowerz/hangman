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

lives = 7
while (lives >=1) do


end