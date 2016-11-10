# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:advanced_infos_for_courses) do
      primary_key :course_id, :advanced_info_id
      foreign_key :course_id, :advanced_info_id
      Date :time
    end
  end
end