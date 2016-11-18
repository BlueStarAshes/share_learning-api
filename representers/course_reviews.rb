# frozen_string_literal: true

# Represents overall course information for JSON API output
class CourseReviewsRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :course_id
  property :review_id
end