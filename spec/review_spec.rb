# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Group Routes' do
  before do
    VCR.insert_cassette REVIEWS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Create a new review' do
    before do
      # TODO: find a better way to populate group!
      DB[:reviews].delete
      DB[:courses].delete
    end

    it '(HAPPY) should successfully create a new review' do
      post 'api/v0.1/reviews',
           { content: HAPPY_REVIEW_CONTENT }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      body = JSON.parse(last_response.body)
      body.must_include 'Successfully'

      Review.count.must_be :>=, 1
    end

    it '(BAD) should report error if given wrong data' do
      post 'api/v0.1/reviews',
           { url: SAD_REVIEW_CONTENT }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 500
      last_response.body.must_include 'Failed'
    end
  end
end