# frozen_string_literal: true

# Represents course in search results for JSON API output
class SearchResultsSingleSourceRepresenter < Roar::Decorator
  include Roar::JSON

  property :count
  collection :courses, extend: SearchResultsCourseRepresenter, class: SearchResultsCourse
end
