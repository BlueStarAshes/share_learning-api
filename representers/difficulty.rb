# frozen_string_literal: true

# Represents overall course information for JSON API output
class DifficultyRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :rating
end