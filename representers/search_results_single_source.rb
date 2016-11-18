# frozen_string_literal: true
require_relative 'search_results_course'

# Represents course in search results for JSON API output
class SearchResultsSingleSourceRepresenter < Roar::Decorator
  include Roar::JSON

  property :count
  collection :courses, extend: SearchResultsCourseRepresenter, class: SearchResultsCourse
end
