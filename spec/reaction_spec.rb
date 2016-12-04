# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Reaction Routes' do
  before do
    VCR.insert_cassette REACTIONS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Create a new reaction' do
    before do
      DB[:reactions].delete
    end

    it '(HAPPY) should successfully create a new reaction' do
      post 'api/v0.1/reactions/new_reaction/',
           HAPPY_REACTION,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200

      Reaction.count.must_be :>=, 1
      Reaction.first.type.must_equal JSON.parse(HAPPY_REACTION)['type']
    end

    it '(BAD) should report error if given wrong data' do
      post 'api/v0.1/reactions/new_reaction/',
           SAD_REACTION,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
    end

    it '(BAD) should report error if given duplicated type of reaction' do
      post 'api/v0.1/reactions/new_reaction/',
           HAPPY_REACTION,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      Reaction.count.must_equal 1

      post 'api/v0.1/reactions/new_reaction/',
           HAPPY_REACTION,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
      Reaction.count.must_equal 1
    end
  end

  describe 'Create a new review_reaction' do
    before do
      DB[:courses].delete
      DB[:reviews].delete
      DB[:reactions].delete
      DB[:review_reactions].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
      next while Course.count < 1

      post "api/v0.1/reviews/#{Course.first.id}",
           { content: HAPPY_REVIEW_CONTENT }.to_json,
           'CONTENT_TYPE' => 'application/json'
      post 'api/v0.1/reactions/new_reaction/',
           HAPPY_REACTION,
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully create a new review_reaction' do
      post 'api/v0.1/reactions/new_review_reaction/',
           {
             review_id: Review.first.id,
             reaction_id: Reaction.first.id
           }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200

      ReviewReaction.count.must_equal 1
    end

    it '(BAD) should report error if given wrong data' do
      post 'api/v0.1/reactions/new_review_reaction/',
           {
             sad_review_id: Review.first.id,
             sad_reaction_id: Reaction.first.id
           }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
    end

    it '(BAD) should report error if given not existing review or reacion id' do
      post 'api/v0.1/reactions/new_review_reaction/',
           {
             review_id: BAD_REVIEW_ID,
             reaction_id: BAD_REACTION_ID
           }.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 422
    end
  end

  describe 'Create a new course_prerequisite_reaction' do
  end
end
