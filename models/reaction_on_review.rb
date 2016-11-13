# frozen_string_literal: true

# Represents a Course's stored information
class ReactionOnReview < Sequel::Model
  many_to_one :review
  many_to_one :reaction
end
