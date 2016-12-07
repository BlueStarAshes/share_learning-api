# frozen_string_literal: true

# Loads data from Facebook group to database
class ShowHelpful
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

  register :validate_course_helpful, lambda { |course_id|
    results = CourseHelpfulsMappingSearchResults.new(CourseHelpful.where(course_id: course_id).all)
    course_helpful_mapping = CourseHelpfulsMappingSearchResultsRepresenter.new(results).to_json
    course_helpful_mapping = JSON.parse(course_helpful_mapping)

    if course_helpful_mapping['course_helpfuls_mapping'].empty?
      Left(Error.new(:not_found, 'There is no helpful rating for the course'))
    else
      Right(course_helpful_mapping)
    end
  }

  register :calculate_avg_rating, lambda { |course_helpful_mapping|
    total_rating = 0
    course_helpful_mapping['course_helpfuls_mapping'].each do |helpful|
      results = HelpfulRepresenter.new(Helpful.find(id: helpful['helpful_id'])).to_json
      results = JSON.parse(results)
      rating = results['rating']
      total_rating += rating
    end
    avg_rating = total_rating / course_helpful_mapping['course_helpfuls_mapping'].length

    Right(avg_rating)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_course_helpful
      step :calculate_avg_rating
    end.call(params)
  end
end
