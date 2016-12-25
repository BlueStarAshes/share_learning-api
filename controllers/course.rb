# frozen_string_literal: true
require 'json'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  # find a course by its id
  get "/#{API_VER}/courses/:id/?" do
    result = FindCourse.call(params)

    if result.success?
      content_type 'application/json'
      CourseRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # store courses to database
  post "/#{API_VER}/courses/?" do
    result = LoadNewCoursesFromAPI.call(params)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
