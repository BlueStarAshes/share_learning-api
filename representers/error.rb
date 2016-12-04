# frozen_string_literal: true
require 'json'

# Represents Error for JSON API output
class ErrorRepresenter < Roar::Decorator
  property :code
  property :message

  ERROR = {
    unprocessable_entity: 422,
    not_found: 404,
    bad_request: 400,
    internal_server_error: 500
  }.freeze

  def to_status_response
    [ERROR[@represented.code], { errors: [@represented.message] }.to_json]
  end
end
