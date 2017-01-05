# frozen_string_literal: true

# Represents overall course information for JSON API output
class ReactionRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :type
  property :emoji
end
