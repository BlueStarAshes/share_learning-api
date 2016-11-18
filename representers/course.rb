# frozen_string_literal: true

# Represents overall course information for JSON API output
class CourseRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :title
  property :source
  property :introduction
  property :link
end