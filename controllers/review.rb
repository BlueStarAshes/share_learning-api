# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/course/:course_id/reviews/?" do

    course = FindCourse.call(params)
    halt 400, "Course (id: #{params[:course_id]}) is not stored" unless course

    course_reviews_mapping_results = CourseReviewsMappingSearchResults.new(Coursereview.where(course_id: params[:course_id]).all)
    halt 400, "reviews stored" unless course_reviews_mapping_results
    
    course_reviews_mapping = CourseReviewsMappingSearchResultsRepresenter.new(course_reviews_mapping_results).to_json
    course_reviews_mapping = JSON.parse(course_reviews_mapping)

    course_reviews = course_reviews_mapping['course_reviews_mapping'].map do |review| 
      ReviewsSearchResults.new(Review.where(id: review['review_id']))
    end
    
    output = []
    course_reviews.each do |course_review|
      review = ReviewsSearchResultsRepresenter.new(course_review).to_json
      review = JSON.parse(review)
      output.push(review['reviews'][0])
    end

    content_type 'application/json'
    output.to_json
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
