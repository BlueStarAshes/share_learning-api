# frozen_string_literal: true

# Represents a Course's stored information
class CourseHelpful < Sequel::Model
  many_to_one :course
  one_to_one :helpful
end
