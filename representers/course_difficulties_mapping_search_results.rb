# frozen_string_literal: true
require_relative 'difficulty'
require_relative 'course_difficulties'

# Represents the difficulties rating of a course
class CourseDifficultiesMappingSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :course_difficulties_mapping, extend: CourseDifficultiesRepresenter, class: CourseDifficulty
end
