# frozen_string_literal: true

# Represents overall course information for JSON API output
class CourseDifficultiesRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :course_id
  property :difficulty_id
end