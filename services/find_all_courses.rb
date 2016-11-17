# frozen_string_literal: true

# Loads all course data from database
class FindAllCourses
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    if (udacity_courses = Course.find(source: 'Udacity')).nil?
      Left(Error.new(:not_found, 'Udacity courses not found'))
    elsif (coursera_courses = Course.find(source: 'Coursera')).nil?
      Left(Error.new(:not_found, 'Coursera courses not found'))
    else
      Right(udacity_courses + coursera_courses)
  end
end