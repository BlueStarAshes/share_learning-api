# frozen_string_literal: true
require 'json'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  # find helpful rating of a course
  get "/#{API_VER}/course/helpful/:course_id/?" do
    result = FindCourse.call(params)

    if result.success?
      content_type 'application/json'
      CourseRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # add helpful rating to course
  post "/#{API_VER}/helpful/:course_id/?" do
    course_id = params[:course_id]
    body_params = JSON.parse request.body.read
    my_rating = body_params['rating']

    print my_rating

    begin
      course = Course.find(id: course_id)
    rescue
      content_type 'text/plain'
      halt 404, "Cannot find course"      
    end
      
    # add helpful rating
    helpful_rating = Helpful.create(rating: my_rating)

    # create helpful rating and course mapping
    helpful_rating_id = helpful_rating.id
    current_time = DateTime.now.strftime("%F %T")

    CourseHelpful.create(
      course_id: course_id,
      helpful_id: helpful_rating_id,
      created_time: current_time
    )

    content_type 'application/json'
    {course_id: course_id, helpful_id: helpful_rating_id, created_time: current_time}.to_json

  end
end
