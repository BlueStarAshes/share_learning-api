# frozen_string_literal: true
require 'json'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  # find helpful rating of a course
  get "/#{API_VER}/course/difficulty/:course_id/?" do
    result = ShowDifficulty.call(params)

    if result.success?
      content_type 'application/json'
      result.value.to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end    
  end

  # add helpful rating to course
  post "/#{API_VER}/difficulty/:course_id/?" do
    course_id = params[:course_id]
    body_params = JSON.parse request.body.read
    my_rating = body_params['rating']  
     
    input = {course_id: course_id, rating: my_rating}
    result = AddDifficulty.call(input)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
