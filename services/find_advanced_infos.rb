# frozen_string_literal: true
require 'share_learning'
require 'dry-monads'

# Loads data from Facebook group to database
class FindAdvancedInfos
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    # group = Group.find(id: params[:id])
    course = Course.find(id: params[:id])
    if course.nil? 
      Left(Error.new(:not_found, "Cannot find advanced information"))
    else
      title = course.title	
      Right(find_advanced_infos(find_course_infos(params[:id]), title))
    end
  end

  def self.find_course_infos(course_id)
  	CourseAdvancedInfo.where(course_id: course_id).all
  end

  def self.find_advanced_infos(course_info, title)
  	all_infos = AllInfos.new(
  	  title,
	  course_info.each do |info|
	    infos = CourseAdvancedInfos.new(
	      info.time,
	      AdvancedInfoRepresenter.new(AdvancedInfo.find(id: info.advanced_info_id)))
	    infos
	  end
	)
	all_infos
  end
end