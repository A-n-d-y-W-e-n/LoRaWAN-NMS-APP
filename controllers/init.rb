# frozen_string_literal: true
require 'sinatra'
require 'sinatra/flash'
require 'slim/include'
require 'econfig'
require 'http'
require 'rack-flash'
require 'json'

require_relative 'base'

Dir.glob("#{File.dirname(__FILE__)}/*.rb").each do |file|
  require file
end
