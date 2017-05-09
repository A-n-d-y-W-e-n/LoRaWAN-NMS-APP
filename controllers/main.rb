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
    session[:username] = username
    session[:password] = password
    if username.length > 0
      results = HTTP.get("#{API_SERVER}/app/#{username}")
      @data = JSON.parse(results.body)
      if results.code == 200 && @data.length > 0
        slim :app
      else
        flash[:error] = "kdowjfo"
        redirect "/user"
      end
    else
      flash[:error] = "kdowjfo"
      redirect "/user"
    end
  end

  get "/node/:username/:app_name/?" do
    username = params[:username]
    app_name = params[:app_name]
    results = HTTP.get("#{API_SERVER}/node/#{username}/#{app_name}")

    if results.body.to_s.length > 2
      @data = JSON.parse(results.body)
      slim :node
    else
      redirect "/app/?username=#{username}"
    end
  end

  get '/gateway/?' do
    results = HTTP.get("#{API_SERVER}/gateway")
    if results.code == 200
      @data = JSON.parse(results.body)
      slim :gateway
    end
  end

  post '/create_app/:username/?' do
    username = params[:username]
    app_name = params[:app_name]
    app_description = params[:app_description]
    results = HTTP.post("#{API_SERVER}/app/#{username}/#{app_name}/#{app_description}")

    redirect "/app/?username=#{username}"
  end

  post '/delete_app/:username/:app_name/?' do
    username = params[:username]
    app_name = params[:app_name]
    app_description = params[:app_description]
    results = HTTP.post("#{API_SERVER}/delete_app/#{username}/#{app_name}")

    redirect "/app/?username=#{username}"
  end

  # add nodes
  post '/add_node/:username/:app_name/?' do
    username = params[:username]
    app_name = params[:app_name]
    DevAddr = params[:DevAddr]
    NwkSKey = params[:NwkSKey]
    AppSKey = params[:AppSKey]
    results = HTTP.post("#{API_SERVER}/node/#{username}/#{app_name}/#{DevAddr}")
    results2 = HTTP.post("#{API_SERVER}/node/abp/#{DevAddr}/#{NwkSKey}/#{AppSKey}")

    redirect "/node/#{username}/#{app_name}/?"
  end

  # delete nodes
  post '/delete_node/:username/:app_name/:node_addr/?' do
    username = params[:username]
    app_name = params[:app_name]
    node_addr = params[:node_addr]
    results = HTTP.post("#{API_SERVER}/delete_node/#{username}/#{app_name}/#{node_addr}")
    results = HTTP.post("#{API_SERVER}/delete_node/abp/#{node_addr}")

    redirect "/node/#{username}/#{app_name}/?"
  end

  # add gateways
  post '/add_gateway/?' do
    gateway_name = params[:gw_name]
    gateway_mac = params[:gw_mac]
    gateway_ip = params[:gw_ip]
    gateway_loc = params[:gw_loc]
    results = HTTP.post("#{API_SERVER}/gateway/#{gateway_name}/#{gateway_mac}/#{gateway_ip}/#{gateway_loc}")

    redirect "/gateway"
  end

  # delete gateways
  post '/delete_gateway/:gw_mac?' do
    gateway_mac = params[:gw_mac]
    results = HTTP.post("#{API_SERVER}/delete_gateway/#{gateway_mac}")

    redirect "/gateway"
  end

  # sign up modal
  post '/create_user/?' do
    new_username = params[:new_username]
    new_user_email = params[:new_user_email]
    new_password = params[:new_password]
    results = HTTP.post("#{API_SERVER}/user/#{new_username}/#{new_user_email}/#{new_password}")

    redirect "/user"
  end

end
