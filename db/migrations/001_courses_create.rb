# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:courses) do
      primary_key :id
      String :title
      String :source
      String :original_source_id
      String :introduction
      String :link
      String :photo
    end
  end
end
