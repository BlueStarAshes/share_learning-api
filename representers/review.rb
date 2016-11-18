# frozen_string_literal: true

# Represents overall course information for JSON API output
class ReviewRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :content
  property :created_time
end