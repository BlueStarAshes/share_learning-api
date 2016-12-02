# frozen_string_literal: true

# Represents a Course's stored information
class Review < Sequel::Model
  one_to_one :courseReview
  one_to_many :reviewReactions
end
