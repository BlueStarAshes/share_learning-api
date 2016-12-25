# frozen_string_literal: true

require_relative 'prerequisites'

# Represents the search results from 'Coursereview' table
class AllCoursePrerequisitesRepresenter < Roar::Decorator
  include Roar::JSON
  collection :prerequisites, extend: PrerequisitesRepresenter, class: Prerequisites
end
