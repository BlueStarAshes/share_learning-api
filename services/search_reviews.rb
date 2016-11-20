# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchReviews
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_course, lambda { |params|
    course_id = params[:course_id]
    course = Course.find(id: course_id)    
    
    if course
      Right(course_id)
    else
      Left(Error.new(:not_found, 'Course not found'))
    end
  }

  register :validate_course_review, lambda { |course_id|
    results = CourseReviewsMappingSearchResults.new(Coursereview.where(course_id: course_id).all)
    
    if results
      course_reviews_mapping = CourseReviewsMappingSearchResultsRepresenter.new(results).to_json
      course_reviews_mapping = JSON.parse(course_reviews_mapping)      
      
      Right(course_reviews_mapping)
    else
      Left(Error.new(:not_found, 'There is no review for the course'))
    end
  }

  register :search_reviews, lambda { |course_reviews_mapping|
    puts course_reviews_mapping
    begin
      course_reviews = course_reviews_mapping['course_reviews_mapping'].map do |review| 
        ReviewsSearchResults.new(Review.where(id: review['review_id']))
      end

      Right(course_reviews)
    rescue
      Left(Error.new(:bad_request, 'Cannot find the reviews'))
    end
  }

  register :generate_output, lambda { |course_reviews|
    output = []
    course_reviews.each do |course_review|
      review = ReviewsSearchResultsRepresenter.new(course_review).to_json
      review = JSON.parse(review)
      output.push(review['reviews'][0])
    end

    Right(output.to_json)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_course_review
      step :search_reviews
      step :generate_output
    end.call(params)
  end
end