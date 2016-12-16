# frozen_string_literal: true

# Loads data from Facebook group to database
class ShowDifficulty
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

  register :validate_course_difficulty, lambda { |course_id|
    results = CourseDifficultiesMappingSearchResults.new(CourseDifficulty.where(course_id: course_id).all)
    course_difficulty_mapping = CourseDifficultiesMappingSearchResultsRepresenter.new(results).to_json
    course_difficulty_mapping = JSON.parse(course_difficulty_mapping)

    if course_difficulty_mapping['course_difficulties_mapping'].empty?
      Left(Error.new(:not_found, 'There is no difficulty rating for the course'))
    else
      Right(course_difficulty_mapping)
    end
  }

  register :calculate_avg_rating, lambda { |course_difficulty_mapping|
    total_rating = 0
    course_difficulty_mapping['course_difficulties_mapping'].each do |difficulty|
      results = DifficultyRepresenter.new(Difficulty.find(id: difficulty['difficulty_id'])).to_json
      results = JSON.parse(results)
      rating = results['rating']
      total_rating += rating
    end
    avg_rating = total_rating / course_difficulty_mapping['course_difficulties_mapping'].length

    Right({'avg_rating': avg_rating})
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_course_difficulty
      step :calculate_avg_rating
    end.call(params)
  end
end
