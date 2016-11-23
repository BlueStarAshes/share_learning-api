# frozen_string_literal: true

# Represents a Course's stored information
class Difficulty < Sequel::Model
  one_to_one :difficultyForCourse
end
