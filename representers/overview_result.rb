# frozen_string_literal: true

# Represents overall search results for JSON API output
class OverviewResultRepresenter < Roar::Decorator
  include Roar::JSON

  property :coursera_count
  property :udacity_count
  property :youtube_count
end
