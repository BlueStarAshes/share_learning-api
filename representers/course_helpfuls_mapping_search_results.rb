# frozen_string_literal: true
require_relative 'review'
require_relative 'course_reviews'

# Represents the search results from 'Coursereview' table
class CourseHelpfulsMappingSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :course_helpfuls_mapping, extend: CourseHelpfulsRepresenter, class: CourseHelpful
end
