# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:course_prerequisite_reactions) do
      primary_key :id
      foreign_key :course_prerequisites_id
      foreign_key :reaction_id
      String :time
    end
  end
end
