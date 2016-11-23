# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:prerequisites) do
      primary_key :id
      String :course_name
    end
  end
end
