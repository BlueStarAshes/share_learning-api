# frozen_string_literal: true

# Represents overall course information for JSON API output
class ReactionsRepresenter < Roar::Decorator
  include Roar::JSON

  property :type
  property :count
end
