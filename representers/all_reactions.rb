# frozen_string_literal: true

require_relative 'reaction'

# Represents the search results from 'Coursereview' table
class AllReactionsRepresenter < Roar::Decorator
  include Roar::JSON
  collection :reactions, extend: ReactionRepresenter, class: Reaction
end
