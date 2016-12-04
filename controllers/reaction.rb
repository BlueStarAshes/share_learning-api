# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  post "/#{API_VER}/reactions/new_reaction/?" do
    input = { request: request.body.read }
    result = AddNewReaction.call(input)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
