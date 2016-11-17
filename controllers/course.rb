# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  # acquire all courses from database
  get "/#{API_VER}/courses/?" do
    result = FindAllCourses.call()
    # result = coursera_courses + udacity_courses

    if result.success?
      CourseRepresenter.new(result).to_json
      # { coursera: coursera_courses, udacity: udacity_courses, youtube: 'inf' }.to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # find a course by its id
  get "/#{API_VER}/courses/:id/?" do
    result = FindCourse.call(params)

    if result.success?
      CourseRepresenter.new(result).to_json

    else
      ErrorRepresenter.new(result.value).to_status_response
    end

    # course_id = params[:id]
    # begin
    #   course = Course.find(id: course_id)

    #   content_type 'application/json'
    #   { id: course.id, title: course.title, source: course.source, \
    #     introduction: course.introduction, link: course.link}.to_json
    # rescue
    #   content_type 'text/plain'
    #   halt 404, "Course (id: #{course_id}) not found"
    # end
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
