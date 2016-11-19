# frozen_string_literal: true
require_relative 'course'

# Represents overall group information for JSON API output
class AllCoursesRepresenter < Roar::Decorator
  include Roar::JSON

  collection :courses, extend: CourseRepresenter, class: Course
end