# frozen_string_literal: true

# Input for SearchReviews
class ReviewsSearchCriteria

  attr_accessor :course_id, :terms

  def initialize(params)
    @course_id = params[:course_id]
    @terms = reasonable_search_terms(params[:search])
  end
end