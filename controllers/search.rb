# frozen_string_literal: true

# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/search/:search_keyword/?" do
    keyword = params[:search_keyword]
    keyword = keyword.tr('+', ' ') if keyword.include? '+'
    begin
      results_coursera =
        Coursera::CourseraCourses.find.search_courses(:all, keyword)

      results_udacity =
        Udacity::UdacityCourse.find.acquire_courses_by_keywords(keyword)

      results_youtube =
        YouTube::YouTubePlaylist.find(keyword: keyword).results

      refined_results_coursera = SearchResultsSingleSource.new(
        results_coursera.count,
        results_coursera.map do |course|
          search_results_course = SearchResultsCourse.new(
            course[:course_name],
            course[:description],
            course[:link],
            course[:photo_url]
          )
          search_results_course
        end
      )

      refined_results_udacity = SearchResultsSingleSource.new(
        results_udacity.count,
        results_udacity.map do |course|
          search_results_course = SearchResultsCourse.new(
            course[:title],
            course[:intro],
            course[:link],
            course[:image]
          )
          search_results_course
        end
      )

      refined_results_youtube = SearchResultsSingleSource.new(
        results_youtube.count,
        results_youtube.map do |course|
          search_results_course = SearchResultsCourse.new(
            course['title'],
            course['description'],
            course['url'],
            course['image']
          )
          search_results_course
        end
      )

      search_results = SearchResults.new(
        refined_results_coursera,
        refined_results_udacity,
        refined_results_youtube
      )

      content_type 'application/json'
      SearchResultsRepresenter.new(search_results).to_json

    end
  end
end
