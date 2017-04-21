# frozen_string_literal: true
folders = 'config'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
