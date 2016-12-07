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
    
    total_rating = 0
    course_helpful_mapping['course_helpfuls_mapping'].each do |helpful|
      results = HelpfulRepresenter.new(Helpful.find(id: helpful['helpful_id'])).to_json
      results = JSON.parse(results)
      rating = results['rating']
      total_rating += rating
    end
    avg_rating = total_rating / course_helpful_mapping['course_helpfuls_mapping'].length
    print avg_rating

    content_type 'text/plain'
    "The average helpful rating of course #{course_id} is : #{avg_rating}"
    
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
end
