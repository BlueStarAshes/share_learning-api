# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:course_helpfuls) do
      primary_key :id
      foreign_key :course_id
      foreign_key :helpful_id
      String :created_time
    end
  end
end
