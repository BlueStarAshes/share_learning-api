# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/overview/?" do
    begin
      coursera_num = Coursera::CourseraApi.total_course_num
      udacity_num = Udacity::UdacityAPI.total_course_num

      content_type 'application/json'
      { coursera: coursera_num, udacity: udacity_num, youtube: 'inf' }.to_json
    rescue
      halt 404, 'Overview not found'
    end
  end
end
