# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  # Get all the instances in Reaction table currently
  get "/#{API_VER}/reactions/?" do
    results = FindAllReactions.call('')

    if results.success?
      AllReactionsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/prerequisite/reactions/:course_prerequisite_id/?" do
    results = ShowPrerequisiteReactions.call(params)

    if results.success?
      CollectedReactionsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/review/reactions/:review_id/?" do
    results = ShowReviewReactions.call(params)

    if results.success?
      CollectedReactionsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

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

  post "/#{API_VER}/reactions/new_review_reaction/?" do
    input = request.body.read
    result = AddNewReviewReaction.call(input)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  post "/#{API_VER}/reactions/new_prerequisite_reaction/?" do
    input = { request: request.body.read }
    result = AddNewPrerequisiteReaction.call(input)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
