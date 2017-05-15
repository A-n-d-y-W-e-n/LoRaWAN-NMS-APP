# frozen_string_literal: true
API_SERVER = 'http://localhost:9292'

class LORAWAN_NMS_APP < Sinatra::Base

  get '/?' do
    @not_found = params[:not_found]
    slim :main
  end

  get '/mqtt_broker' do
    @username = session[:username]
    @password = session[:password]
    slim :mqtt_broker
  end

  get '/user/?' do
    @username = session[:username]
    @password = session[:password]

    results = HTTP.get("#{API_SERVER}/user/?username=#{@username}")
    @data = JSON.parse(results.body)

    slim :user
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get '/app/?' do
    @username = params[:username]
    @password = params[:password]
    session[:username] = @username
    session[:password] = @password

    if @username.length > 0 and @password.length > 0
      results = HTTP.get("#{API_SERVER}/user/?username=#{@username.gsub(/( )/, '+')}")
      @cre = JSON.parse(results.body)
      if @cre.length > 0 and @cre[0]['password'] == @password
        results2 = HTTP.get("#{API_SERVER}/app/?username=#{@username.gsub(/( )/, '+')}")
        @data = JSON.parse(results2.body)
        if results2.code == 200
          slim :app
        else
          redirect "/?not_found=1#login"
        end
      else
        redirect "/?not_found=1#login"
      end
    else
      redirect "/?not_found=1#login"
    end
  end

  get "/node/?" do
    @username = session[:username]
    @password = session[:password]
    @app_name = params[:app_name]

    content_type 'application/json'
    results = HTTP.get("#{API_SERVER}/node/?username=#{@username}&app_name=#{@app_name.gsub(/( )/, '+')}")
    @data = JSON.parse(results.body)
    slim :node
  end

  get '/gateway/?' do
    @username = session[:username]
    @password = session[:password]
    results = HTTP.get("#{API_SERVER}/gateway")
    if results.code == 200
      @data = JSON.parse(results.body)
      slim :gateway
    end
  end

  post '/create_app/?' do
    @username = session[:username]
    @password = session[:password]
    app_name = params[:app_name].gsub(/( )/, '+')
    app_description = params[:app_description].gsub(/( )/, '+')

    results = HTTP.post("#{API_SERVER}/create_app/?username=#{@username}&app_name=#{app_name}&app_description=#{app_description}")

    redirect "/app/?username=#{@username}&password=#{@password}"
  end

  post '/delete_app/?' do
    @username = session[:username]
    @password = session[:password]
    app_name = params[:app_name].gsub(/( )/, '+')

    results = HTTP.get("#{API_SERVER}/node/?username=#{@username}&app_name=#{app_name}")
    @data = JSON.parse(results.body)
    if @data.length == 2
      results2 = HTTP.post("#{API_SERVER}/delete_app/?username=#{@username}&app_name=#{app_name}")
    end
    redirect "/app/?username=#{@username}&password=#{@password}"
  end

  # add nodes
  post '/add_node/?' do
    @username = session[:username]
    @password = session[:password]
    app_name = params[:app_name].gsub(/( )/, '+')
    devaddr = params[:DevAddr]
    nwkskey = params[:NwkSKey]
    appskey = params[:AppSKey]
    if devaddr.length == 8 and nwkskey.length == 32 and appskey.length == 32
      results2 = HTTP.post("#{API_SERVER}/add_node/abp/?DevAddr=#{devaddr}&NwkSKey=#{nwkskey}&AppSKey=#{appskey}")
      if results2.code == 200
        results = HTTP.post("#{API_SERVER}/add_node/?username=#{@username}&app_name=#{app_name}&node_addr=#{devaddr}&node_nwkskey=#{nwksky}&node_appskey=#{appskey}")
      end
      redirect "/node/?username=#{@username}&app_name=#{app_name}"
    end
    redirect "/node/?username=#{@username}&app_name=#{app_name}"
  end

  # delete nodes
  post '/delete_node/?' do
    @username = session[:username]
    @password = session[:password]
    app_name = params[:app_name].gsub(/( )/, '+')
    node_addr = params[:node_addr]

    results = HTTP.post("#{API_SERVER}/delete_node/?username=#{@username}&app_name=#{app_name}&node_addr=#{node_addr}")
    results = HTTP.post("#{API_SERVER}/delete_node/abp/?DevAddr=#{node_addr}")

    redirect "/node/?username=#{@username}&app_name=#{app_name}"
  end

  # add gateways
  post '/add_gateway/?' do
    @username = session[:username]
    gateway_name = params[:gw_name].gsub(/( )/, '+')
    gateway_mac = params[:gw_mac].gsub(/:/, '')
    gateway_ip = params[:gw_ip]
    gateway_loc = params[:gw_loc].gsub(/( )/, '+')

    results = HTTP.post("#{API_SERVER}/add_gateway/?gateway_name=#{gateway_name}&gateway_mac=#{gateway_mac}&gateway_ip=#{gateway_ip}&gateway_loc=#{gateway_loc}&gateway_username=#{@username}")

    redirect "/gateway"
  end

  # delete gateways
  post '/delete_gateway/?' do
    gateway_mac = params[:gateway_mac]
    results = HTTP.post("#{API_SERVER}/delete_gateway/?gateway_mac=#{gateway_mac}")

    redirect "/gateway"
  end

  # sign up modal
  post '/create_user/?' do
    new_username = params[:new_username]
    new_user_email = params[:new_user_email]
    new_password = params[:new_password]
    if new_username.length > 0 and new_user_email.length > 0 and new_password.length > 0 and !new_username.strip.include?" " and !new_user_email.strip.include?" " and !new_password.strip.include? " "
      results = HTTP.post("#{API_SERVER}/create_user/?username=#{new_username}&user_email=#{new_user_email}&password=#{new_password}")
      redirect "/#login"
    else
      redirect "/?not_found=2#login"
    end
  end

  # get the node data
  get '/node_data/?' do
    @username = session[:username]
    @password = session[:password]
    @app_name = params[:app_name]
    @node_addr = params[:node_addr]

    results = HTTP.get("#{API_SERVER}/node_data/?node_addr=#{@node_addr}")
    @data = JSON.parse(results.body)

    slim :node_data
  end

end
