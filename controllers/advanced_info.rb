# frozen_string_literal: true
# require 'json'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/course/advanced_info/:id/?" do
    # course_id = params[:id]
    results = FindAdvancedInfos.call(params)

    if results.success?
      content_type 'application/json'
      (results.value)
    else
      ErrorRepresenter.new(result.value.to_json).to_status_response
    end      
  end

  post "/#{API_VER}/advanced_info/:id/?" do
    result = CreateAdvancedInfos.call(request.body.read, params)
    
    if result.success?
      AdvancedInfoRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end        
  end
end
