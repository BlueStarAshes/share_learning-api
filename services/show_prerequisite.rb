# frozen_string_literal: true

class ShowPrerequisite
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_course, lambda { |params|
    course_id = params[:course_id]
    course = Course.find(id: course_id)

    if course
      Right(course_id)
    else
      Left(Error.new(:not_found, 'Course not found'))
    end
  }

  register :validate_course_prerequisite, lambda { |course_id|
    results = CoursePrerequisite.where(course_id: course_id).all
    if results.empty?
      Left(Error.new(:not_found, 'There is no prerequisite for this course'))
    else
      Right(results)
    end
  }

  register :get_course_prerequisite, lambda { |results|
    all = AllCoursePrerequisites.new(
      results.map do |item|
        Prerequisites.new(Prerequisite.find(id: item.prerequisite_id))
      end
    )
    Right(all)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_course_prerequisite
      step :get_course_prerequisite
    end.call(params)
  end
end
