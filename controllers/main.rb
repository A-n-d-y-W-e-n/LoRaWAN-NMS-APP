# frozen_string_literal: true
API_SERVER = 'http://localhost:9292'

class LORAWAN_NMS_APP < Sinatra::Base

  get '/?' do
    @not_found = params[:not_found]
    slim :main
  end

  get '/app/?' do
    @username = params[:username]
    @password = params[:password]
    session[:username] = @username
    session[:password] = @password

    if @username.length > 0 and @password.length > 0
      results = HTTP.get("#{API_SERVER}/user/?username=#{@username}")
      @cre = JSON.parse(results.body)
      if @cre.length > 0 and @cre[0]['password'] == @password
        results2 = HTTP.get("#{API_SERVER}/app/?username=#{@username}")
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
    app_name = params[:app_name]
    app_description = params[:app_description]

    results = HTTP.post("#{API_SERVER}/create_app/?username=#{@username}&app_name=#{app_name}&app_description=#{app_description}")

    redirect "/app/?username=#{@username}&password=#{@password}"
  end

  post '/delete_app/?' do
    @username = session[:username]
    @password = session[:password]
    app_name = params[:app_name].gsub(/( )/, '+')

    results = HTTP.post("#{API_SERVER}/delete_app/?username=#{@username}&app_name=#{app_name}")

    redirect "/app/?username=#{@username}&password=#{@password}"
  end

  # add nodes
  post '/add_node/?' do
    @username = session[:username]
    @password = session[:password]
    app_name = params[:app_name].gsub(/( )/, '+')
    DevAddr = params[:DevAddr]
    NwkSKey = params[:NwkSKey]
    AppSKey = params[:AppSKey]

    results = HTTP.post("#{API_SERVER}/add_node/?username=#{@username}&app_name=#{app_name}&node_addr=#{DevAddr}&node_nwkskey=#{NwkSKey}&node_appskey=#{AppSKey}")
    results2 = HTTP.post("#{API_SERVER}/add_node/abp/?DevAddr=#{DevAddr}&NwkSKey=#{NwkSKey}&AppSKey=#{AppSKey}")

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
    @password = session[:password]
    gateway_name = params[:gw_name]
    gateway_mac = params[:gw_mac]
    gateway_ip = params[:gw_ip]
    gateway_loc = params[:gw_loc]

    results = HTTP.post("#{API_SERVER}/add_gateway/?gateway_name=#{gateway_name}&gateway_mac=#{gateway_mac}&gateway_ip=#{gateway_ip}&gateway_loc=#{gateway_loc}&gateway_username=#{@username}")

    redirect "/gateway"
  end

  # delete gateways
  post '/delete_gateway/?' do
    gateway_mac = params[:gw_mac]
    results = HTTP.post("#{API_SERVER}/delete_gateway/?gateway_mac=#{gateway_mac}")

    redirect "/gateway"
  end

  # sign up modal
  post '/create_user/?' do
    new_username = params[:new_username]
    new_user_email = params[:new_user_email]
    new_password = params[:new_password]
    results = HTTP.post("#{API_SERVER}/user/#{new_username}/#{new_user_email}/#{new_password}")

    redirect "/#login"
  end

end
