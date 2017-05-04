# frozen_string_literal: true
API_SERVER = 'http://localhost:9292'

class LORAWAN_NMS_APP < Sinatra::Base
  get '/' do
    slim :main
  end

  post '/user/?' do
    redirect "/#login"
  end

  get '/app/?' do
    username = params[:username]
    password = params[:password]
    results = HTTP.get("#{API_SERVER}/app/#{username}")
    @data = JSON.parse(results.body)
    slim :app
  end

  get "/node/:username/:app_name/?" do
    username = params[:username]
    app_name = params[:app_name]
    results = HTTP.get("#{API_SERVER}/node/#{username}/#{app_name}")
    @data = JSON.parse(results.body)
    slim :node
  end

  get '/gw/?' do
    slim :gw
  end



end
