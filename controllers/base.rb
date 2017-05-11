# frozen_string_literal: true

# configure based on environment
class LORAWAN_NMS_APP < Sinatra::Base

  use Rack::Session::Cookie, :key => 'rack.session',
                             :path => '/',
                             :secret => 'your_secret'
  use Rack::Flash

  set :views, File.expand_path('../../views_html', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  after do
    content_type 'text/html'
  end

end
