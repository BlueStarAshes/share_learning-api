# frozen_string_literal: true

# Search courses from Coursera, Udacity, and YouTube using external API rather
# than retrieving from our own databse currently
class SearchCourses
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :parse_keyword, lambda { |params|
    keyword = params[:search_keyword]
    keyword = keyword.tr('+', ' ') if keyword.include? '+'
    if keyword
      # Right(keyword: keyword)
      Right(SearchResults.new)
    else
      Left(Error.new(:no_keyword, 'Keyword not given'))
    end
  }

  register :search_coursera, lambda { |input|


    results = SearchResults.new
    # input[:results].coursera = refined_results_coursera
    # Right(input)
    Right(results)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :parse_keyword
      # step :search_coursera
    end.call(params)
  end
end
