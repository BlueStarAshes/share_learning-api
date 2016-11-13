# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
require 'vcr'
require 'webmock'

require './init.rb'

include Rack::Test::Methods

def app
  ShareLearningAPI
end

FIXTURES_FOLDER = 'spec/fixtures'.freeze
CASSETTES_FOLDER = "#{FIXTURES_FOLDER}/cassettes".freeze
SEARCH_CASSETTE = 'search'.freeze
OVERVIEW_CASSETTE = 'overview'.freeze
COURSES_CASSETTE = 'courses'.freeze
REVIEWS_CASSETTE = 'reviews'.freeze

VCR.configure do |c|
  c.cassette_library_dir = CASSETTES_FOLDER
  c.hook_into :webmock

  c.filter_sensitive_data('<API_KEY>') do
    app.config.YOUTUBE_API_KEY
  end
end

HAPPY_COURSE_ID = 1
SAD_COURSE_ID = 0

HAPPY_REVIEW_CONTENT = 'HAPPY review'
SAD_REVIEW_CONTENT = 'SAD review'