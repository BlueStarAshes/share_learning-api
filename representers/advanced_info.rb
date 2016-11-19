# frozen_string_literal: true

# Represents overall group information for JSON API output
class AdvancedInfoRepresenter < Roar::Decorator
  include Roar::JSON

  property :prerequisite
  property :difficulty
  property :helpful
end