# frozen_string_literal: true
folders = 'controllers'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
