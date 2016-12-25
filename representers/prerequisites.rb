# frozen_string_literal: true

# Represents overall course information for JSON API output
class PrerequisitesRepresenter < Roar::Decorator
  include Roar::JSON

  property :course_prerequisite_id
  property :prerequisite_id
  property :course_name
end
