# frozen_string_literal: true
require_relative 'review'
require_relative 'course_reviews'

# Represents the search results from 'Coursereview' table
class CourseReviewsMappingSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :course_reviews_mapping, extend: CourseReviewsRepresenter, class: CourseReview
end
