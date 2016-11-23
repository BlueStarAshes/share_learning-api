# frozen_string_literal: true

# Represents a Course's stored information
class Prerequisite < Sequel::Model
  one_to_one :prerequisiteForCourse
end
