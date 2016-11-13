# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Group Routes' do
  before do
    VCR.insert_cassette GROUPS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find stored course by its id' do
    before do
      DB[:courses].delete
      DB[:reviews].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should find a course given a correct id' do
      get "api/v0.1/course/#{Course.first.id}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      course_data = JSON.parse(last_response.body)
      course_data['id'].must_be :>, 0
      course_data['title'].length.must_be :>, 0
    end

    it '(SAD) should report if a course is not found' do
      get "api/v0.1/course/#{SAD_COURSE_ID}"

      last_response.status.must_equal 404
      last_response.body.must_include SAD_COURSE_ID
    end
  end
end