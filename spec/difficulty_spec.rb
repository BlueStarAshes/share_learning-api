# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Difficulty Routes' do
  before do
    VCR.insert_cassette DIFFICULTY_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'add difficulty rating to a course' do
    before do
      DB[:courses].delete
      DB[:difficulties].delete
      DB[:course_difficulties].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully add a new difficulty rating' do
      post "api/v0.1/difficulty/#{Course.first.id}",
           { rating: HAPPY_RATING }.to_json

      Difficulty.count.must_be :>=, 1
      CourseDifficulty.count.must_be :>=, 1
    end

    it '(BAD) should report error if given wrong course id' do
      post "api/v0.1/difficulty/#{BAD_COURSE_ID}",
           { rating: HAPPY_RATING }.to_json

      last_response.status.must_equal 404
    end  

    it '(BAD) should report error if rating is not an integer' do
      post "api/v0.1/difficulty/#{Course.first.id}",
           { rating: BAD_RATING }.to_json

      last_response.status.must_equal 422
    end
  end

  describe 'Read course difficulty information' do
    before do
      DB[:difficulties].delete
      DB[:course_difficulties].delete
      DB[:courses].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully read course difficulty information' do
      post "api/v0.1/difficulty/#{Course.first.id}",
           { rating: HAPPY_RATING }.to_json
      get "api/v0.1/course/difficulty/#{Course.first.id}/?"

      last_response.status.must_equal 200
      last_response.body.must_include 'The average difficulty rating'
    end

    it '(SAD) should report error if course is not found' do
      get "api/v0.1/course/difficulty/#{BAD_COURSE_ID}/?"

      last_response.status.must_equal 404
    end

    it '(SAD) should report error if difficulty ratings are not found' do
      get "api/v0.1/course/difficulty/#{Course.last.id}/?"

      last_response.status.must_equal 404
    end
  end  
end