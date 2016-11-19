# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/search/:search_keyword/?" do
    results = SearchCourses.call(params)

    if results.success?
      content_type 'application/json'
      SearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
