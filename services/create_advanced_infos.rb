# frozen_string_literal: true
require 'share_learning'
require 'dry-monads'
require 'json'
require 'date'
# Adds advanced infos to database
class CreateAdvancedInfos
  extend Dry::Monads::Either::Mixin

  def self.call(request, params)
    body_params = JSON.parse request
    if body_params
      info = create_advanced_infos(body_params)
      info_for_course = create_courses_advanced_infos(params[:id])
      Right(info)
    else
      Left(Error.new(:cannot_process, "Cannot add advanced information"))
    end
  end

  private_class_method

  def self.create_advanced_infos(body_params)
      info = AdvancedInfo.create(
        prerequisite: body_params['prerequisite'],
        difficulty: body_params['difficulty'],
        helpful: body_params['helpful']
      )    
      info
  end

  def self.create_courses_advanced_infos(course_id)
    current_time = DateTime.now.strftime("%F %T")
    info_for_course = CourseAdvancedInfo.create(
      course_id: course_id,
      advanced_info_id: AdvancedInfo.last.id,
      time: current_time
    ) 
    info_for_course   
  end
end