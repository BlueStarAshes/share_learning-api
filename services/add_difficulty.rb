# frozen_string_literal: true
require 'date'


# Loads data from Facebook group to database
class AddDifficulty
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

  register :validate_rating, lambda { |params|
    my_rating = params[:rating]

    if my_rating >= 0.0 && my_rating <= 5.0
      Right(params)
    else
      Left(Error.new(:unprocessable_entity, 'rating must be an integer between 0~5'))
    end
  }

  register :add_difficulty, lambda { |params|
    begin
      my_rating = params[:rating]
      difficulty = Difficulty.create(rating: my_rating)

      Right({difficulty: difficulty, course_id: params[:course_id]})
    rescue
      Left(Error.new(:bad_request, 'Failed to create difficulty rating for course'))
    end
  }

  register :add_difficulty_course_mapping, lambda { |params|
    begin
      current_time = DateTime.now.strftime("%F %T")
      CourseDifficulty.create(
       course_id: params[:course_id],
       difficulty_id: params[:difficulty].id,
       created_time: current_time
      )

      Right('Successfully add difficulty rating')
    rescue
      Left(Error.new(:bad_request, 'Failed to create difficulty rating for course'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_rating
      step :add_difficulty
      step :add_difficulty_course_mapping
    end.call(params)
  end
end
