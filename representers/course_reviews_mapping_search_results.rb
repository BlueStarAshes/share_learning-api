# frozen_string_literal: true
require_relative 'review'

# Represents the search results from 'Coursereview' table
class CourseReviewsMappingSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON
  
  collection :course_reviews_mapping, extend: CourseReviewsRepresenter, class: Coursereview
end