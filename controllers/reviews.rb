# frozen_string_literal: true
require 'date'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/course/:id/reviews/?" do
    course_id = params[:id]
    begin
      course = Course.find(id: course_id)

      content_type 'application/json'
      { coursera: coursera_courses, udacity: udacity_courses, youtube: 'inf' }.to_json
    rescue
      halt 404, 'Courses not found'
    end
  end

  post "/#{API_VER}/reviews/?" do
    
    begin
      body_params = JSON.parse request.body.read
      review_content = body_params['content']  
      current_time = DateTime.now.strftime("%F %T")

      Review.create(
        content: review_content,
        time: current_time
      )

    rescue
      content_type 'text/plain'
      halt 500, "Cannot create review"
    end
  end
end
