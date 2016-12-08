# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:difficulties) do
      primary_key :id
      Integer :rating
    end
  end
end
