# frozen_string_literal: true
require 'sinatra'
require 'sequel'
puts "start"
configure :development do
  puts "12345"
  ENV['DATABASE_URL'] = 'sqlite://db/dev.db'
end

configure :test do
  ENV['DATABASE_URL'] = 'sqlite://db/test.db'
end

configure :development, :production do
  require 'hirb'
  Hirb.enable
end

configure do
  DB = Sequel.connect(ENV['DATABASE_URL'])
end
