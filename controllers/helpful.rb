# frozen_string_literal: true
require 'json'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  # find helpful rating of a course
  get "/#{API_VER}/course/helpful/:course_id/?" do
    course_id = params[:course_id]

    begin
      course = Course.find(id: course_id)
    rescue
      content_type 'text/plain'
      halt 404, "Cannot find course"      
    end

    results = CourseHelpfulsMappingSearchResults.new(CourseHelpful.where(course_id: course_id).all)
    course_helpful_mapping = CourseHelpfulsMappingSearchResultsRepresenter.new(results).to_json
    course_helpful_mapping = JSON.parse(course_helpful_mapping)
    
    course_helpfuls = course_helpful_mapping['course_helpfuls_mapping'].map do |helpful|
      HelpfulsSearchResults.new(Helpful.find(id: helpful['helpful_id']))
    end
    #print course_helpfuls
    
    output = []
    course_helpfuls.each do |course_helpful|
      print course_helpful
      helpful = HelpfulsSearchResultsRepresenter.new(course_helpful).to_json
      #helpful = JSON.parse(helpful)
      #print helpful
      #output.push(helpful['rating'][0])
    end

    content_type 'application/json'
    output.to_json
    
  end

  # add helpful rating to course
  post "/#{API_VER}/helpful/:course_id/?" do
    course_id = params[:course_id]
    body_params = JSON.parse request.body.read
    my_rating = body_params['rating']  
     
    input = {course_id: course_id, rating: my_rating}
    result = AddHelpful.call(input)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
end
