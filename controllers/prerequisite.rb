# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/course/prerequisite/:course_id/?" do
    results = ShowPrerequisite.call(params)

    if results.success?
      AllCoursePrerequisitesRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end    
  end

  post "/#{API_VER}/prerequisite/:course_id/?" do
    course_id = params[:course_id]
    body_params = JSON.parse request.body.read
    input_params = {course_id: course_id, prerequisite: body_params['prerequisite']}
    result = AddPrerequisite.call(input_params)
    
    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end        
  end
end
