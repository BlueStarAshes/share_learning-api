# frozen_string_literal: true

# Represents a Course's stored information
class ReactionOnPrerequisiteForCourse < Sequel::Model
  many_to_one :reaction
  one_to_one :prerequisiteForCourse
end
