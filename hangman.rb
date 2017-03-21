require 'sinatra'
require 'sinatra/reloader'

backend_secretNum = rand(100)

get '/' do
  erb :index, :locals => {:frontend_number => backend_secretNum}
end
# "render the ERB template named index and create a local variable for the
#  template named fnumber which has the same value as the number variable from
#  this server code."
