# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:reviews_on_courses) do
      primary_key [:course_id, :review_id], name: :items_pk
      foreign_key :course_id
      foreign_key :review_id
    end
  end
end
