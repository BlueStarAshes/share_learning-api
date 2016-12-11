# frozen_string_literal: true

# Represents overall course information for JSON API output
class PrerequisitesRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :course_name
end
