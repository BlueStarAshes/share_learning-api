# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Advanced Info Routes' do
  before do
    VCR.insert_cassette ADVANCEDINFO_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Add new advanced info' do
    before do
      DB[:advanced_infos].delete
      DB[:course_advanced_infos].delete
      post 'api/v0.1/courses',
           'CONTENT_TYPE' => 'application/json'         
    end

    it '(HAPPY) should successfully add advanced info' do
      post "api/v0.1/advanced_info/#{Course.first.id}",
           {prerequisite: HAPPY_PREREQUISITE}.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      AdvancedInfo.count.must_be :>=, 1
    end
  end

  describe 'Get all advanced info for a course' do
    it '(BAD) should report error if could not post data' do
      post "api/v0.1/advanced_info/#{SAD_COURSE_ID}"

      last_response.status.must_equal 500
      last_response.body.must_include 'Cannot add'
    end

    it '(HAPPY) should get advanced infos with the course id' do
      get "api/v0.1/course/advanced_info/#{Course.first.id}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
    end

    it '(SAD) should report if the info of the course id is not found' do
      get "api/v0.1/course/advanced_info/#{SAD_COURSE_ID}"
      last_response.status.must_equal 404 
    end   
  end
end
