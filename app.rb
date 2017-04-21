# frozen_string_literal: true

require 'sinatra'
require 'slim'

get '/' do
    slim :main
end

get '/nodes' do
    slim :node
end
