# frozen_string_literal: true
require 'json'
# Share Learning API web service
class ShareLearningAPI < Sinatra::Base
  extend Econfig::Shortcut

  get "/#{API_VER}/course/advanced_info/:id/?" do
    course_id = params[:id]
    begin
      # results = []
      # course_info = CourseAdvancedInfo.where(course_id: course_id).all
      course_info = CourseAdvancedInfo.find(course_id: course_id)
      # course_info.each do |info|
      #   advanced_info = AdvancedInfo.find(id: info.advanced_info_id)
      #   results << AdvancedInfoRepresenter.new(advanced_info).to_json
      # end


      # print AdvancedInfo.find(id: course_info.advanced_info_id)
      a = AdvancedInfo.find(id: course_info.advanced_info_id)
      results = CourseAdvancedInfos.new(
        course_info.time,
        CourseAdvancedInfosRepresenter.new(AdvancedInfo.find(id: course_info.advanced_info_id))
        # course_info.each do |info|
        #   AdvancedInfo.find(id: info.advanced_info_id)
        # end
      )
      print JSON.parse(results.to_json)
      # r = CourseAdvancedInfosRepresenter.new(results).to_json
      # print r
      # refined_results_youtube = SearchResultsSingleSource.new(
      #   results_youtube.count,
      #   results_youtube.map do |course|
      #     search_results_course = SearchResultsCourse.new(
      #       course['title'],
      #       course['description'],
      #       course['url'],
      #       course['image']
      #     )
      #     search_results_course
      #   end
      # )

      print results
      content_type 'application/json'
      results.to_json
    rescue 
      halt 404, 'Courses not found'     
    end
  end

  post "/#{API_VER}/advanced_info/:id/?" do
    course_id = params[:id]
    begin
      body_params = JSON.parse request.body.read
      current_time = DateTime.now.strftime("%F %T")

      # table: advanced_infos
      info = AdvancedInfo.create(
        prerequisite: body_params['prerequisite'],
        difficulty: body_params['difficulty'],
        helpful: body_params['helpful']
      )

      # table: course_advanced_infos
      info_for_course = CourseAdvancedInfo.create(
        course_id: course_id,
        advanced_info_id: AdvancedInfo.last.id,
        time: current_time
      )

      content_type 'text/plain'
      body "Successfully add advanced information"     
        
    rescue 
      content_type 'text/plain'
      halt 500, "Cannot add advanced information"     
    end
  end
end
