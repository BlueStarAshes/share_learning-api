# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require_relative '../app'

include Rack::Test::Methods

def app
  ShareLearningAPI
end

FIXTURES_FOLDER = 'spec/fixtures'.freeze
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes".freeze
SEARCH_CASSETTE = 'search'.freeze
OVERVIEW_CASSETTE = 'overview'.freeze 

# read credentials from a Yaml file into environment variables
if File.file?('config/credentials.yml')
  credentials = YAML.load(File.read('config/app.yml'))
  ENV['YOUTUBE_API_KEY'] = credentials[:youtube_api_key]
end

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<API_KEY>') do
    ENV['YOUTUBE_API_KEY']
  end
end