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
    results = CourseReviewsMappingSearchResults.new(CourseReview.where(course_id: course_id).all)
    course_reviews_mapping = CourseReviewsMappingSearchResultsRepresenter.new(results).to_json
    course_reviews_mapping = JSON.parse(course_reviews_mapping)

    if course_reviews_mapping['course_reviews_mapping'].empty?
      Left(Error.new(:not_found, 'There is no review for the course'))
    else
      Right(course_reviews_mapping)
    end
  }

  register :search_reviews, lambda { |course_reviews_mapping|
    course_reviews = AllCourseReviews.new(
      course_reviews_mapping['course_reviews_mapping'].map do |review|
        r = Review.find(id: review['review_id'])
        Reviews.new(r.id, r.content, r.created_time)
      end
    )

    Right(course_reviews)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_course_review
      step :search_reviews
    end.call(params)
  end
end
