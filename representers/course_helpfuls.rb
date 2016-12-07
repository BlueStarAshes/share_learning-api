# frozen_string_literal: true

# Represents overall course information for JSON API output
class CourseHelpfulsRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :course_id
  property :helpful_id
end