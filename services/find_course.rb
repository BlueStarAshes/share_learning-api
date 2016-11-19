# frozen_string_literal: true

# Loads course data from database
class FindCourse
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    if (course = Course.find(id: params[:id])).nil?
      Left(Error.new(:not_found, 'Course not found'))
    else
      Right(course)
    end
  end
end