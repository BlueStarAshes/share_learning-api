# frozen_string_literal: true
require 'date'

# Loads data from Facebook group to database
class PostReview
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

  register :validate_content, lambda { |params|
    body_params = JSON.parse params[:request]
    review_content = body_params['content']
    
    if review_content
      Right({course_id: params[:course_id], review_content: review_content})
    else
      Left(Error.new(:cannot_process, 'The review has no content'))
    end
  }

  register :create_review, lambda { |params|
    begin
      current_time = DateTime.now.strftime("%F %T")

      review = Review.create(
        content: params[:review_content],
        created_time: current_time  # the time when the review is created
      )

      Right({review: review, course_id: params[:course_id]})
    rescue
      Left(Error.new(:bad_request, 'Failed to create review'))
    end
  }

  register :create_review_course_mapping, lambda { |params|
    begin
      Coursereview.create(
        course_id: params[:course_id],
        review_id: params[:review].id
      )

      Right('Successfully create a new review')
    rescue
      Left(Error.new(:bad_request, 'Failed to create review'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_course
      step :validate_content
      step :create_review
      step :create_review_course_mapping
    end.call(params)
  end
end