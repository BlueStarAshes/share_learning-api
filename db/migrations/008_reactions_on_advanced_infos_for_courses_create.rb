# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:reactions_on_advanced_infos_for_courses) do
      primary_key [:course_id, :advanced_info_for_course_id, :reaction_id], name: :items_pk
      foreign_key :course_id
      foreign_key :advanced_info_for_course_id
      foreign_key :reaction_id
      Date :time
    end
  end
end
