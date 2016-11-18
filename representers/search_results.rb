# frozen_string_literal: true

# Represents overall search results for JSON API output
class SearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :coursera, extend: SearchResultsSingleSourceRepresenter
  property :udacity, extend: SearchResultsSingleSourceRepresenter
  property :youtube, extend: SearchResultsSingleSourceRepresenter
end
