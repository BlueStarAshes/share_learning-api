# frozen_string_literal: true
require_relative 'helpful'
require_relative 'course_helpfuls'

# Represents the search results from 'Coursereview' table
class CourseHelpfulsMappingSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :course_helpfuls_mapping, extend: CourseHelpfulsRepresenter, class: CourseHelpful
end
