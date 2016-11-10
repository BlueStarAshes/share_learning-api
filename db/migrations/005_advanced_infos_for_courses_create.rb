# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:advanced_infos_for_courses) do
      foreign_key :course_id
      foreign_key :advanced_info_id
      Date :time
      primary_key [:course_id, :advanced_info_id], :name=> :items_pk
    end
  end
end
