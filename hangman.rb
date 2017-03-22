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

