# frozen_string_literal: true
require 'json'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  # acquire all courses from database
  get "/#{API_VER}/courses/?" do
    udacity_results = FindAllCourses.call('Udacity')
    coursera_results = FindAllCourses.call('Coursera')
    if udacity_results.success? && coursera_results.success?
      udacity_courses = AllCoursesRepresenter.new(udacity_results.value).to_json  # output String object
      udacity_courses = JSON.parse(udacity_courses) # parse String to JSON object
  
      coursera_courses = AllCoursesRepresenter.new(coursera_results.value).to_json  # output String object
      coursera_courses = JSON.parse(coursera_courses) # parse String to JSON object

      content_type 'application/json'
      {udacity: udacity_courses['courses'], coursera: coursera_courses['courses'], youtube: 'inf'}.to_json
    else
      ErrorRepresenter.new(udacity_results.value).to_status_response if !udacity_results.success?
      ErrorRepresenter.new(coursera_results.value).to_status_response if !coursera_results.success?
    end
  end

  # find a course by its id
  get "/#{API_VER}/courses/:id/?" do
    result = FindCourse.call(params)

    if result.success?
      content_type 'application/json'
      CourseRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # store courses to database
  post "/#{API_VER}/courses/?" do
    result = LoadCoursesFromAPI.call(params)

    if result.success?
      content_type 'text/plain'
      body result.value
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
