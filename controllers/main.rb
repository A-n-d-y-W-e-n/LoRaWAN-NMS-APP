# frozen_string_literal: true
API_SERVER = 'http://localhost:9292'

class LORAWAN_NMS_APP < Sinatra::Base
  get '/' do

    # username = 'andy'
    # results = HTTP.get("#{API_SERVER}/app/#{username}")

    slim :main
  end

  post '/user/?' do
    redirect "/#login"
  end

  get '/app/?' do
    username = params[:username]
    password = params[:password]
    results = HTTP.get("#{API_SERVER}/app/#{username}")
    @data = results
    puts @data
    slim :app
  end

  get '/gw/?' do
    slim :gw
  end



end
