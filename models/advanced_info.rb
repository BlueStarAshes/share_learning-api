# frozen_string_literal: true

# Represents a Course's stored information
class AdvancedInfo < Sequel::Model
  one_to_one :advancedInfoForCourse
end
