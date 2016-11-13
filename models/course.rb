# frozen_string_literal: true

# Represents a Course's stored information
class Course < Sequel::Model
  one_to_many :reviewOnCourses
  one_to_many :advancedInfoForCourses
end
