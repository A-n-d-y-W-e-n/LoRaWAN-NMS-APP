# frozen_string_literal: true

# configure based on environment
class LORAWAN_NMS_APP < Sinatra::Base
  # extend Econfig::Shortcut
  # set :session_secret, 'secret'
  # enable :sessions
  # configure do
  #   Econfig.env = settings.environment.to_s
  #   Econfig.root = File.expand_path('..', settings.root)
  # end

  # use Rack::Session::Cookie
  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :secret => 'your_secret'
  use Rack::Flash

  set :views, File.expand_path('../../views_html', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  after do
    content_type 'text/html'
  end

  # def self.api_ver_url
  #    [config.API_SERVER, config.API_VER].join('/')
  # end
end
