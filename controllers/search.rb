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
      content_type 'application/json'
      {
        # Search results from Coursera
        coursera:
        {
          count: results_coursera.count,
          courses: results_coursera.map do |course|
            shorten_result = {}
            shorten_result[:title] = course[:course_name]
            shorten_result[:introduction] = course[:description]
            shorten_result[:resource_url] = course[:link]
            shorten_result[:photo_url] = course[:photo_url]
            shorten_result
          end
        },
        # Search results from Udacity
        udacity:
        {
          count: results_udacity.count,
          courses: results_udacity.map do |course|
            shorten_result = {}
            shorten_result[:title] = course[:title]
            shorten_result[:introduction] = course[:intro]
            shorten_result[:resource_url] = course[:link]
            shorten_result[:photo_url] = course[:image]
            shorten_result
          end
        },
        # Search results from Youtube
        youtube:
        {
          count: results_youtube.count,
          courses: results_youtube.map do |course|
            shorten_result = {}
            shorten_result[:title] = course['title']
            shorten_result[:introduction] = course['description']
            shorten_result[:resource_url] = course['url']
            shorten_result[:photo_url] = course['image']
            shorten_result
          end
        }
      }.to_json
    end
  end
end
