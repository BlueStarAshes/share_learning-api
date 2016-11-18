# frozen_string_literal: true
require_relative 'search_results_single_source'

# Represents overall search results for JSON API output
class SearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :coursera, extend: SearchResultsSingleSourceRepresenter
  property :udacity, extend: SearchResultsSingleSourceRepresenter
  property :youtube, extend: SearchResultsSingleSourceRepresenter
end
