# frozen_string_literal: true

require_relative 'reactions'

# Represents the search results from 'Coursereview' table
class AllReactionsRepresenter < Roar::Decorator
  include Roar::JSON
  collection :reactions, extend: ReactionsRepresenter, class: Reactions
end
