# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/overview/?" do
    udacity_results = FindAllCourses.call('Udacity')
    coursera_results = FindAllCourses.call('Coursera')
    
    if udacity_results.success? && coursera_results.success?
      udacity_courses = AllCoursesRepresenter.new(udacity_results.value).to_json  # output String object
      udacity_courses = JSON.parse(udacity_courses) # parse String to JSON object
  
      coursera_courses = AllCoursesRepresenter.new(coursera_results.value).to_json  # output String object
      coursera_courses = JSON.parse(coursera_courses) # parse String to JSON object

      coursera_num = coursera_courses['courses'].length
      udacity_num = udacity_courses['courses'].length

      overview_result = OverviewResult.new(
        coursera_num,
        udacity_num,
        'inf'
      )

      content_type 'application/json'
      OverviewResultRepresenter.new(overview_result).to_json
    else
      ErrorRepresenter.new(udacity_results.value).to_status_response if !udacity_results.success?
      ErrorRepresenter.new(coursera_results.value).to_status_response if !coursera_results.success?     
    end
  end
end
