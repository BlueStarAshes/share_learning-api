# frozen_string_literal: true
require 'date'

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/course/:id/reviews/?" do
    begin
      course_id = params[:id]
      course = Course.find(id: course_id)
      halt 400, "Course (id: #{course_id}) is not stored" unless course

      course_reviews = Coursereview.where(course_id: course_id).all
      halt 400, "reviews stored" unless course_reviews
      
      output = []
      course_reviews.each do |course_review|
        review = Review.find(id: course_review.review_id)
        output.push({content: review.content, created_time: review.created_time})
      end
      
      content_type 'application/json'
      output.to_json
    rescue
      halt 404, 'Reviews not found'
    end
  end

  post "/#{API_VER}/reviews/:course_id/?" do
    begin
      course_id = params[:course_id]
      course = Course.find(id: course_id)
      halt 400, "Course (id: #{course_id}) is not stored" unless course

      body_params = JSON.parse request.body.read
      review_content = body_params['content']  
      halt 400, "The review has no content to be stored" unless review_content

      current_time = DateTime.now.strftime("%F %T")
      

      Review.create(
        content: review_content,
        created_time: current_time  # the time when the review is created
      )

      Coursereview.create(
        course_id: course_id,
        review_id: Review.last.id
      )

      content_type 'text/plain'
      body 'Successfully create a new review'

    rescue
      content_type 'text/plain'
      halt 500, "Failed to create review"
    end
  end
end
