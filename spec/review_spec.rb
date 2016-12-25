# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Review Routes' do
  before do
    VCR.insert_cassette REVIEWS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Create a new review' do
    before do
      DB[:reviews].delete
      DB[:courses].delete
      LoadNewCoursesFromAPI.call('')
    end

    it '(HAPPY) should successfully create a new review' do
      post "api/v0.1/reviews/#{Course.first.id}",
           { content: HAPPY_REVIEW_CONTENT }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200

      Review.count.must_be :>=, 1
    end

    it '(BAD) should report error if given wrong data' do
      post "api/v0.1/reviews/#{Course.first.id}",
           { url: SAD_REVIEW_CONTENT }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
    end

    it '(BAD) should report error if given wrong course id' do
      post "api/v0.1/reviews/#{BAD_COURSE_ID}",
           { url: SAD_REVIEW_CONTENT }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 404
    end
  end

  describe 'Read course reviews' do
    before do
      DB[:reviews].delete
      DB[:courses].delete
      LoadNewCoursesFromAPI.call('')
    end

    it '(HAPPY) should successfully read course reviews' do
      post "api/v0.1/reviews/#{Course.first.id}",
           { content: HAPPY_REVIEW_CONTENT }.to_json,
           'CONTENT_TYPE' => 'application/json'

      get "api/v0.1/course/#{Course.first.id}/reviews/?"

      last_response.status.must_equal 200
      last_response.body.must_include 'reviews'
    end

    it '(SAD) should report error if course is not found' do
      get "api/v0.1/course/#{BAD_COURSE_ID}/reviews/?"

      last_response.status.must_equal 404
    end

    it '(SAD) should report error if reviews are not found' do
      get "api/v0.1/course/#{Course.last.id}/reviews/?"

      last_response.status.must_equal 404
    end
  end
end
