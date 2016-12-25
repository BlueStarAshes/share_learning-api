# frozen_string_literal: true

require_relative 'review'

# Represents the search results from 'Coursereview' table
class AllCourseReviewsRepresenter < Roar::Decorator
  include Roar::JSON
  collection :reviews, extend: ReviewRepresenter, class: Review
end
