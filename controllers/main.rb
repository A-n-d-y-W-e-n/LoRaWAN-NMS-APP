# frozen_string_literal: true
API_SERVER = 'http://localhost:9292'

class LORAWAN_NMS_APP < Sinatra::Base

  # homepage
  get '/?' do
    @not_found = params[:not_found]
    slim :main
  end

  # MQTT broker info
  get '/mqtt_broker' do
    @username = session[:username]
    slim :mqtt_broker
  end

  # user info
  get '/user/?' do
    @username = session[:username]

    results = HTTP.get("#{API_SERVER}/user/?username=#{@username}")
    @data = JSON.parse(results.body)

    slim :user
  end

  # login
  post '/login/?' do
    @username = params[:username]
    @password = params[:password]
    session[:username] = @username

    if @username.length > 0 and @password.length > 0
      results = HTTP.get("#{API_SERVER}/user/?username=#{@username.gsub(/( )/, '+')}")
      @cre = JSON.parse(results.body)
      if @cre.length > 0 and @cre[0]['password'] == @password
        session[:login] = 1
        redirect "/app"
      else
        redirect "/?not_found=1#login"
      end
    else
      redirect "/?not_found=1#login"
    end
  end

  # logout
  get '/logout' do
    session.clear
    redirect "/"
  end

  # application page
  get '/app/?' do
    @error = params[:error]
    @username = session[:username]

    if session[:login] == 1
      results2 = HTTP.get("#{API_SERVER}/app/?username=#{@username.gsub(/( )/, '+')}")
      @data = JSON.parse(results2.body)
      if results2.code == 200
        @app_node_number = []

        # get the number of nodes of each application
        @data.each do |a|
          results3 = HTTP.get("#{API_SERVER}/app/node_number/?app_name=#{a['app_name'].gsub(/( )/, '+')}&username=#{@username.gsub(/( )/, '+')}")
          @temp = JSON.parse(results3.body)
          hash = { :app_name => "#{a['app_name']}", :node_number => "#{@temp[0]['COUNT(app_name)']}" }
          @app_node_number.push(hash)
        end
        @app_node_number = @app_node_number.to_json

        slim :app
      else
        redirect "/?not_found=1#login"
      end
    else
      redirect "/?not_found=1#login"
    end
  end

  # node page
  get "/node/?" do
    @error = params[:error]
    @username = session[:username]
    @app_name = params[:app_name]

    content_type 'application/json'
    results = HTTP.get("#{API_SERVER}/node/?username=#{@username}&app_name=#{@app_name.gsub(/( )/, '+')}")
    @data = JSON.parse(results.body)
    slim :node
  end

  # gateway page
  get '/gateway/?' do
    @error = params[:error]
    @username = session[:username]
    results = HTTP.get("#{API_SERVER}/gateway")
    if results.code == 200
      @data = JSON.parse(results.body)
      slim :gateway
    end
  end

  # create an application
  post '/create_app/?' do
    @username = session[:username]
    app_name = params[:app_name].gsub(/( )/, '+')
    app_description = params[:app_description].gsub(/( )/, '+')

    results = HTTP.post("#{API_SERVER}/create_app/?username=#{@username}&app_name=#{app_name}&app_description=#{app_description}")
    if results.code == 200
      redirect "/app"
    else
      redirect "/app/?error=1"
    end
  end

  # delete an application
  post '/delete_app/?' do
    @username = session[:username]
    app_name = params[:app_name].gsub(/( )/, '+')

    results = HTTP.get("#{API_SERVER}/node/?username=#{@username}&app_name=#{app_name}")
    @data = JSON.parse(results.body)
    if @data.length == 0
      results2 = HTTP.post("#{API_SERVER}/delete_app/?username=#{@username}&app_name=#{app_name}")
      redirect "/app"
    else
      redirect "/app/?&error=2"
    end
  end

  # add a node
  post '/add_node/?' do
    @username = session[:username]
    app_name = params[:app_name].gsub(/( )/, '+')
    devaddr = params[:DevAddr]
    nwkskey = params[:NwkSKey]
    appskey = params[:AppSKey]
    if devaddr.length == 8 and nwkskey.length == 32 and appskey.length == 32
      results2 = HTTP.post("#{API_SERVER}/add_node/abp/?DevAddr=#{devaddr}&NwkSKey=#{nwkskey}&AppSKey=#{appskey}")
      if results2.code == 200
        results = HTTP.post("#{API_SERVER}/add_node/?username=#{@username}&app_name=#{app_name}&node_addr=#{devaddr}&node_nwkskey=#{nwkskey}&node_appskey=#{appskey}")
        redirect "/node/?app_name=#{app_name}"
      else
        redirect "/node/?app_name=#{app_name}&error=1"
      end
    else
      redirect "/node/?app_name=#{app_name}&error=1"
    end
  end

  # delete a node
  post '/delete_node/?' do
    @username = session[:username]
    app_name = params[:app_name].gsub(/( )/, '+')
    node_addr = params[:node_addr]
    results = HTTP.post("#{API_SERVER}/delete_node/abp/?DevAddr=#{node_addr}")
    if results.code == 200
      results2 = HTTP.post("#{API_SERVER}/delete_node/?username=#{@username}&app_name=#{app_name}&node_addr=#{node_addr}")
      redirect "/node/?app_name=#{app_name}"
    else
      redirect "/node/?app_name=#{app_name}&error=2"
    end
  end

  # add gateways
  post '/add_gateway/?' do
    @username = session[:username]
    gateway_name = params[:gw_name].gsub(/( )/, '+')
    gateway_mac = params[:gw_mac].gsub(/:/, '')
    gateway_ip = params[:gw_ip]
    gateway_loc = params[:gw_loc].gsub(/( )/, '+')

    results = HTTP.post("#{API_SERVER}/add_gateway/?gateway_name=#{gateway_name}&gateway_mac=#{gateway_mac}&gateway_ip=#{gateway_ip}&gateway_loc=#{gateway_loc}&gateway_username=#{@username}")
    if results.code == 200
      redirect "/gateway"
    else
      redirect "/gateway/?error=1"
    end
  end

  # delete gateways
  post '/delete_gateway/?' do
    gateway_mac = params[:gateway_mac]

    results = HTTP.post("#{API_SERVER}/delete_gateway/?gateway_mac=#{gateway_mac}")
    if results.code == 200
      redirect "/gateway"
    else
      redirect "/gateway/?error=2"
    end
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
    @app_name = params[:app_name]
    @node_addr = params[:node_addr]

    results = HTTP.get("#{API_SERVER}/node_data/?node_addr=#{@node_addr}")
    @data = JSON.parse(results.body)

    slim :node_data
  end

  # get gateway log
  get '/gateway_log/?' do
    @username = session[:username]
    @gateway_name = params[:gateway_name]
    @gateway_ip = params[:gateway_ip]

    results = HTTP.get("#{API_SERVER}/gateway_log/?gateway_ip=#{@gateway_ip}")
    @data = JSON.parse(results.body)
    if !@data[0]['MIN(rssi)'].nil?
      @distance = (10 ** ((-50-@data[0]['MIN(rssi)'])/20)).round(2)
    end
    slim :gateway_log
  end

end
