# frozen_string_literal: true

# Represents a Course's stored information
class CoursePrerequisiteReaction < Sequel::Model
  many_to_one :reaction
  many_to_one :coursePrerequisite
end
