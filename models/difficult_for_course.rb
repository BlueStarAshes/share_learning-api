# frozen_string_literal: true

# Represents a Course's stored information
class CourseDifficulty < Sequel::Model
  many_to_one :course
  one_to_one :difficulty
end
