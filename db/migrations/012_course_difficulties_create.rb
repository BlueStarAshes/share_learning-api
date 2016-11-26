# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:course_difficulties) do
      primary_key :id
      foreign_key :course_id
      foreign_key :difficulty_id       
      String :time
    end
  end
end
