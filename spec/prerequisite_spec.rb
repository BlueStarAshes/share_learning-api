# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Prerequisite Routes' do
  before do
    VCR.insert_cassette PREREQUISITE_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'add prerequisite to a course' do
    before do
      DB[:courses].delete
      DB[:prerequisites].delete
      DB[:course_prerequisites].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully add a new prerequisite' do
      post "api/v0.1/prerequisite/#{Course.first.id}",
           { prerequisite: HAPPY_PREREQUISITE }.to_json

      Prerequisite.count.must_be :>=, 1
    end

    it '(BAD) should report error if given wrong course id' do
      post "api/v0.1/prerequisite/#{BAD_COURSE_ID}",
           { prerequisite: HAPPY_PREREQUISITE }.to_json

      last_response.status.must_equal 404
    end  

    it '(BAD) should report error if prerequisite is empty' do
      post "api/v0.1/prerequisite/#{Course.first.id}",
           { prerequisite: BAD_PREREQUISITE }.to_json

      last_response.status.must_equal 422
    end
  end

  describe 'Read course prerequisite information' do
    before do
      DB[:courses].delete
      DB[:prerequisites].delete
      DB[:course_prerequisites].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'
    end

    it '(HAPPY) should successfully read course prerequisite information' do
      post "api/v0.1/prerequisite/#{Course.first.id}",
           { prerequisite: HAPPY_PREREQUISITE }.to_json

      get "api/v0.1/course/prerequisite/#{Course.first.id}/?"

      last_response.status.must_equal 200
      last_response.body.must_include 'prerequisites'
    end

    it '(SAD) should report error if course is not found' do
      get "api/v0.1/course/prerequisite/#{BAD_COURSE_ID}/?"

      last_response.status.must_equal 404
    end

    it '(SAD) should report error if prerequisite are not found' do
      get "api/v0.1/course/prerequisite/#{Course.last.id}/?"

      last_response.status.must_equal 404
    end
  end  
end
