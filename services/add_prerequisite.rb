# frozen_string_literal: true
require 'date'

# Adds prerequisite to database
class AddPrerequisite
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_course, lambda { |params|
    course_id = params[:course_id]
    course = Course.find(id: course_id)

    if course
      Right(params)
    else
      Left(Error.new(:not_found, 'Course not found'))
    end
  }

  register :validate_prerequisite_type, lambda { |params|
    course_name = params[:prerequisite]
    if course_name && course_name != nil && course_name.length > 0
      Right(params)
    else
      Left(Error.new(:unprocessable_entity, 'prerequisite is empty'))
    end
  }

  register :check_prerequisite_not_duplicate, lambda { |params|
    course_id = params[:course_id]
    course_name = params[:prerequisite].strip().split(" ").map {|word| word.capitalize}.join(" ")
    course_prerequisite = CoursePrerequisite.where(course_id: course_id).all
    course_prerequisite.each do |pre|
      @prerequisite = Prerequisite.find(id: pre.prerequisite_id, course_name: course_name)
    end
    if @prerequisite 
      Left(Error.new(:unprocessable_entity, 'the prerequisite for this course has already existed'))
    else
      Right(params)
    end
  }

  register :add_prerequisite, lambda { |params|
    begin
      course_name = params[:prerequisite].strip().split(" ").map {|word| word.capitalize}.join(" ")
      my_prerequisite = Prerequisite.create(course_name: course_name)

      Right({prerequisite: my_prerequisite, course_id: params[:course_id]})
    rescue
      Left(Error.new(:bad_request, 'Failed to create helpful rating for course'))
    end
  }

   register :add_course_prerequisite, lambda { |params|
    begin
      current_time = DateTime.now.strftime("%F %T")
      CoursePrerequisite.create(
       course_id: params[:course_id],
       prerequisite_id: params[:prerequisite].id,
       time: current_time
      )

      Right('Successfully add prerequisite')
    rescue
      Left(Error.new(:bad_request, 'Failed to create prerequisite'))
    end
  } 

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_prerequisite_type
      step :check_prerequisite_not_duplicate
      step :add_prerequisite
      step :add_course_prerequisite
    end.call(params)
  end
end
