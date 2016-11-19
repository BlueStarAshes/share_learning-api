# frozen_string_literal: true

# Represents course in search results for JSON API output
class SearchResultsCourseRepresenter < Roar::Decorator
  include Roar::JSON

  property :title
  property :introduction
  property :resource_url
  property :photo_url
end
