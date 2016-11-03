# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Overview courses' do
  before do
    VCR.insert_cassette OVERVIEW_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  it 'should be able to get the number of courses on Coursera' do
    get 'api/v0.1/overview'
    overview_data = JSON.parse(last_response.body)
    overview_data['coursera'].must_be :>=, 0
  end

  it 'should be able to get the number of courses on Udecity' do
    get 'api/v0.1/overview'
    overview_data = JSON.parse(last_response.body)
    overview_data['udecity'].must_be :>=, 0
  end

  it 'should be able to get the number of courses on YouTube' do
    get 'api/v0.1/overview'
    overview_data = JSON.parse(last_response.body)
    overview_data['youtube'].must_equal('inf')
  end
end

