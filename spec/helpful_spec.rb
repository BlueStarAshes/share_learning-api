# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Helpful Routes' do
  before do
    VCR.insert_cassette HELPFUL_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'add helpful rating to a course' do
    before do
      DB[:courses].delete
      DB[:helpfuls].delete
      DB[:course_helpfuls].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully add a new helpful rating' do
      post "api/v0.1/helpful/#{Course.first.id}",
           { rating: HAPPY_RATING }.to_json

      Helpful.count.must_be :>=, 1
    end

    it '(BAD) should report error if given wrong course id' do
      post "api/v0.1/helpful/#{BAD_COURSE_ID}",
           { rating: HAPPY_RATING }.to_json

      last_response.status.must_equal 404
    end  

    it '(BAD) should report error if rating is not an integer' do
      post "api/v0.1/helpful/#{Course.first.id}",
           { rating: BAD_RATING }.to_json

      last_response.status.must_equal 422
    end
  end

  describe 'Read course helpful information' do
    before do
      DB[:helpfuls].delete
      DB[:course_helpfuls].delete
      DB[:courses].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully read course helpful information' do
      post "api/v0.1/helpful/#{Course.first.id}",
           { rating: HAPPY_RATING }.to_json

      get "api/v0.1/course/helpful/#{Course.first.id}/?"

      last_response.status.must_equal 200
      last_response.body.must_include 'The average helpful rating'
    end

    it '(SAD) should report error if course is not found' do
      get "api/v0.1/course/helpful/#{BAD_COURSE_ID}/?"

      last_response.status.must_equal 404
    end

    it '(SAD) should report error if helpful ratings are not found' do
      get "api/v0.1/course/helpful/#{Course.last.id}/?"

      last_response.status.must_equal 404
    end
  end  
end