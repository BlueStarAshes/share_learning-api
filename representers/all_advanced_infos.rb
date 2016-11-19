# frozen_string_literal: true
require_relative 'course_advanced_infos'

# Represents overall search results for JSON API output
class AllAdvancedInfosRepresenter < Roar::Decorator
  include Roar::JSON
  property :title
  property :all_infos, extend: CourseAdvancedInfosRepresenter
end