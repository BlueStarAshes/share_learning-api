# frozen_string_literal: true

# Represents overall course information for JSON API output
class HelpfulRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :rating
end