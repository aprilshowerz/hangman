require 'sinatra'
require 'sinatra/reloader'

# backend_secretNum = rand(100)
#
# get '/' do
#   erb :index, :locals => {:frontend_number => backend_secretNum}
#
#   backend_guess = params[:guess]
# end
# "render the ERB template named index and create a local variable for the
#  template named fnumber which has the same value as the number variable from
#  this server code."
get '/' do

	erb :index, :locals => {:}

backend_guess = params[:word_input]
end

post '/name' do

	backend_name = params[:name_input]

	#erb :greeting, :locals => {:user_name => user_name}
	erb :age, :locals => {:user_name => backend_name}
end

post '/user_age' do

	backend_name = params[:name_input]
	backend_age = params[:age_input]

	erb :favorite_nums, :locals => {:user_name => backend_name, :age => backend_age}
end

post '/favorite_nums' do
	backend_name = params[:name_input]
	backend_age = params[:age_input].to_i
	backend_num_1 = params[:fav_input_1].to_i
	backend_num_2 = params[:fav_input_2].to_i
	backend_num_3 = params[:fav_input_3].to_i
	sum = (backend_num_1 + backend_num_2 + backend_num_3)

	results = 'less than'
		if (sum > backend_age)
				results = 'greater than'
			elsif (sum == backend_age)
				results = 'equal to'
			else
				results
		end
erb :final_feedback, :locals => {:user_name => backend_name, :age => backend_age,
	:fav_num_1 => backend_num_1, :fav_num_2 => backend_num_2, :fav_num_3 => backend_num_3,
	 :sum => sum, :results => results}
end

post 'final_feedback' do
	backend_name = params[:name_input]
	backend_age = params[:age_input].to_i
	backend_num_1 = params[:fav_input_1].to_i
	backend_num_2 = params[:fav_input_2].to_i
	backend_num_3 = params[:fav_input_3].to_i

erb :final_feedback, :locals => {:user_name => backend_name, :age => backend_age,
	:fav_num_1 => backend_num_1, :fav_num_2 => backend_num_2, :fav_num_3 => backend_num_3,
	 :sum => sum, :results => results}
end
