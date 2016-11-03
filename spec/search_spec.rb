require_relative 'spec_helper'

describe 'Search Routes' do
  HAPPY_SEARCH_KEYWORD = 'machine learning'.freeze
  SAD_SEARCH_KEYWORD = 'no_way_this_is_a_class,_never!'.freeze

  before do
    VCR.insert_cassette SEARCH_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Retrieve resource from Coursera, Udacity, and Youtube' do
    it 'HAPPY: should retrieve relating resource with the HAPPY keyword' do
      get "api/v0.1/search?#{HAPPY_SEARCH_KEYWORD}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      resource_data = JSON.parse(last_response.body)

      available_external_apis = %w(coursera udacity youtube)
      external_api_info_keys = %w(count courses)
      course_info_keys = %w(title course_url description photo_url)

      available_external_apis.each do |external_api|
        resource_data.key?(external_api).must_equal true

        single_resource_data = resource_data[external_api]
        external_api_info_keys.each do |info_key|
          single_resource_data.key?(info_key).must_equal true
        end

        courses_count = single_resource_data['count']
        courses_count.must_be :>=, 0

        courses = single_resource_data['courses']
        courses.count.must_equal courses_count
        next unless courses_count > 0
        courses.each do |course|
          course_info_keys.each do |info_key|
            course.key?(info_key).must_equal true
          end
        end
      end
    end

    it 'SAD: should retrieve no any resource with the SAD keyword' do
      get "api/v0.1/search?#{SAD_SEARCH_KEYWORD}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      resource_data = JSON.parse(last_response.body)

      available_external_apis = %w(coursera udacity youtube)
      external_api_info_keys = %w(count courses)

      available_external_apis.each do |external_api|
        resource_data.key?(external_api).must_equal true

        single_resource_data = resource_data[external_api]
        external_api_info_keys.each do |info_key|
          single_resource_data.key?(info_key).must_equal true
        end

        courses_count = single_resource_data['count']
        courses_count.must_equal 0

        courses = single_resource_data['courses']
        courses.count.must_equal courses_count
      end
    end
  end
end
