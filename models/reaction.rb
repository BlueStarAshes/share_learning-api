# frozen_string_literal: true

# Represents a Course's stored information
class Reaction < Sequel::Model
  one_to_one :reactionOnReview
  one_to_one :reactionOnAdvancedInfoForCourse
end
