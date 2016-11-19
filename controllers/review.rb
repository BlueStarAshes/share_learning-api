# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/course/:course_id/reviews/?" do
    input = {course_id: params[:course_id], request: request.body.read}
    result = SearchReviews.call(input)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  post "/#{API_VER}/reviews/:course_id/?" do
    input = {course_id: params[:course_id], request: request.body.read}
    result = PostReview.call(input)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
