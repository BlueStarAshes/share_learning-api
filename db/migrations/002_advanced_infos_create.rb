# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:advanced_infos) do
      primary_key :id
      String :prerequisite
      Integer :difficulty
      Integer :helpful
    end
  end
end
