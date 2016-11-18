# frozen_string_literal: true

# Loads all course data from database
class FindAllCourses
  extend Dry::Monads::Either::Mixin

  def self.call()
  	coursera_courses = Course.find(source: 'Coursera')
    udacity_courses = Course.where(source: 'Udacity')
    # courses = coursera_courses + udacity_courses

    if coursera_courses.nil?
      Left(Error.new(:not_found, 'Coursera courses not found'))   
    elsif udacity_courses.nil?
      Left(Error.new(:not_found, 'Udacity courses not found'))
    else
      # Right(coursera: coursera_courses, udacity: udacity_courses)
      Right(coursera_courses)
    end
  end
end