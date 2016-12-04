# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Reaction Routes' do
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

      last_response.status.must_equal 400
    end

    it '(BAD) should successfully create a new reaction' do
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
  end

  describe 'Create a new course_prerequisite_reaction' do
  end
end
