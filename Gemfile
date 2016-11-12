# frozen_string_literal: true
source 'https://rubygems.org'

gem 'sinatra'
gem 'puma'
gem 'json'
gem 'econfig'

gem 'share_learning'
gem 'sequel'

group :development, :test do
  gem 'pry-byebug'
  gem 'sqlite3'
end

group :development do
  gem 'rerun'

  gem 'flog'
  gem 'flay'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'

  gem 'rack-test'
  gem 'rake'

  gem 'vcr'
  gem 'webmock'
end

group :development, :production do
  gem 'tux'
  gem 'hirb'
end

# group :production do
  # gem 'pg'
# end
