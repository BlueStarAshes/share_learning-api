# frozen_string_literal: true
require_relative 'advanced_info'

# Represents overall group information for JSON API output
class CourseAdvancedInfosRepresenter < Roar::Decorator
  include Roar::JSON
  property :create_time
  collection :advanced_infos, extend: AdvancedInfoRepresenter, class: AdvancedInfo
end
