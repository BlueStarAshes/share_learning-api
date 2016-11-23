# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:course_prerequisites) do
      primary_key :id
      Date :time
    end
  end
end
