# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:reaction_on_course_prerequisites) do
      primary_key :id
      # primary_key [:course_id, :advanced_info_for_course_id, :reaction_id],\
      # name: :items_pk
      foreign_key :course_id
      foreign_key :course_prerequisites_id
      foreign_key :reaction_id
      String :time
    end
  end
end
