# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:reactions) do
      primary_key :id
      String :type
    end
  end
end