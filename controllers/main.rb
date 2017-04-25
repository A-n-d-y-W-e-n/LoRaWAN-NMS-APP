# frozen_string_literal: true

class LORAWAN_NMS_APP < Sinatra::Base
  get '/' do
      slim :main
  end

  get '/login/?' do
      slim :login
  end


  get '/nodes/?' do
      slim :node
  end

end
