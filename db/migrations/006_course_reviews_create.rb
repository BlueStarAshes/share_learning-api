# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:course_reviews) do
      primary_key :id
      foreign_key :course_id
      foreign_key :review_id
    end
  end
end
