# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:coursereviews) do
      # primary_key [:course_id, :review_id], name: :items_pk
      primary_key :id
      foreign_key :course_id
      foreign_key :review_id
    end
  end
end
