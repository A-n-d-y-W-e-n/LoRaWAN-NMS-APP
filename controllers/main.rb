# frozen_string_literal: true
API_SERVER = 'http://localhost:9292'

class LORAWAN_NMS_APP < Sinatra::Base
  get '/' do
    slim :main
  end

  get '/user/?' do
    redirect "/#login"
  end

  get '/app/?' do
    username = params[:username]
    password = params[:password]
    results = HTTP.get("#{API_SERVER}/app/#{username}")
    @data = JSON.parse(results.body)
    if @data[0]['app_name'] != nil
      slim :app
    else
      redirect "/user"
    end
  end

  get "/node/:username/:app_name/?" do
    username = params[:username]
    app_name = params[:app_name]
    results = HTTP.get("#{API_SERVER}/node/#{username}/#{app_name}")
    if results.code == 200
      @data = JSON.parse(results.body)
      slim :node
    end
  end

  get '/gw/?' do
    results = HTTP.get("#{API_SERVER}/gateway")
    if results.code == 200
      @data = JSON.parse(results.body)
      slim :gw
    end
  end

  post '/create_node/:username/:app_name/?' do
    username = params[:username]
    app_name = params[:app_name]
    DevAddr = params[:DevAddr]
    NwkSKey = params[:NwkSKey]
    AppSKey = params[:AppSKey]
    puts username
    puts app_name
    puts DevAddr
    puts NwkSKey
    puts AppSKey

    redirect "/node/#{username}/#{app_name}/?"
  end

  post '/create_app/:username/?' do
    username = params[:username]
    app_name = params[:app_name]
    app_description = params[:app_description]
    results = HTTP.post("#{API_SERVER}/app/#{username}/#{app_name}/#{app_description}")

    redirect "/app/?username=#{username}"
  end
end
