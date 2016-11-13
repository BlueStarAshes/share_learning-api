# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/courses/?" do
    begin
      coursera_courses = Coursera::CourseraCourses.find.courses
      udacity_courses = Udacity::UdacityCourse.find.acquire_all_courses

      content_type 'application/json'
      { coursera: coursera_courses, udacity: udacity_courses, youtube: 'inf' }.to_json
    rescue
      halt 404, 'Courses not found'
    end
  end

  post "/#{API_VER}/courses/" do
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
        my_course.save
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
            my_course.save            
   
          end
        end
      end

      content_type 'text/plain'
      body 'Add courses finish'
    rescue
      content_type 'text/plain'
      halt 500, "Cannot update courses"
    end
  end
end
