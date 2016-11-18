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
    begin
      # acquire all courses on Udacity
      udacity_courses = Udacity::UdacityCourse.find.acquire_all_courses
      udacity_courses.each do |course|
        my_course = Course.create(
          title: course[:title],
          source: 'Udacity',
          original_source_id: course[:id],
          introduction: course[:intro], 
          link: course[:link], 
          photo: course[:image]
        )

      end

      # acquire all courses on Coursera
      coursera_courses = Coursera::CourseraCourses.find.courses
      coursera_courses.each do |item|
        item.each.with_index do |course, index| 
          if index == 1
            my_course = Course.create(
              title: course[:course_name],
              source: 'Coursera',
              original_source_id: course[:course_id],
              introduction: course[:description], 
              link: course[:link], 
              photo: course[:photo_url]
            )  
          end
        end
      end

      content_type 'text/plain'
      body 'Add courses finish'
    rescue
      content_type 'text/plain'
      halt 500, "Cannot create courses"
    end
  end
end
