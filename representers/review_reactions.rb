# frozen_string_literal: true

# Represents overall course information for JSON API output
class ReviewReactionsRepresenter < Roar::Decorator
  include Roar::JSON

  property :review_id
  property :reaction_id
end
