# frozen_string_literal: true

# Represents overall course information for JSON API output
class HelpfulRatingRepresenter < Roar::Decorator
  include Roar::JSON

  property :avg_rating
end