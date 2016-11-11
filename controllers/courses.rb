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
      # coursera_courses = Coursera::CourseraCourses.find.courses
      udacity_courses = Udacity::UdacityCourse.find.acquire_all_courses
      udacity_courses.each do |course|
        my_course = Course.create(
          title: course['title'],
          id: course['id'], 
          introduction: course['introduction'], 
          link: course['link'], 
          photo: course['photo']
        )
      end

      # course_id = params[:id]
      # posting = Posting.find(id: posting_id)
      # halt 400, "Posting (id: #{posting_id}) is not stored" unless posting
      # updated_posting = FaceGroup::Posting.find(id: posting.fb_id)
      # if updated_posting.nil?
      #   halt 404, "Posting (id: #{posting_id}) not found on Facebook"
      # end

      # posting.update(
      #   created_time:   updated_posting.created_time,
      #   updated_time:   updated_posting.updated_time,
      #   message:        updated_posting.message,
      #   name:           updated_posting.name,
      #   attachment_title:         updated_posting.attachment&.title,
      #   attachment_description:   updated_posting.attachment&.description,
      #   attachment_url:           updated_posting.attachment&.url
      # )
      # posting.save


      content_type 'text/plain'
      body 'Add courses finish'
    rescue
      content_type 'text/plain'
      halt 500, "Cannot update courses"
    end
  end
end
