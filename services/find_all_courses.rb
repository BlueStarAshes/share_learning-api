# frozen_string_literal: true

# Loads all course data from database
class FindAllCourses
  extend Dry::Monads::Either::Mixin

  def self.call(source)
    if (course = AllCourses.new(Course.where(source: source).all)).nil?
      Left(Error.new(:not_found, 'Course not found'))
    else
      Right(course)
    end
  end
end