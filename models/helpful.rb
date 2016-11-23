# frozen_string_literal: true

# Represents a Course's stored information
class Helpful < Sequel::Model
  one_to_one :helpfulForCourse
end
