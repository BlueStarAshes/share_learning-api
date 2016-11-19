# frozen_string_literal: true
require_relative 'review'

# Represents overall group information for JSON API output
class ReviewsSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON
  
  collection :reviews, extend: ReviewRepresenter, class: Review
end