require 'sinatra'

get '/search' do
	slim :search
end