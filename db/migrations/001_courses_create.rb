# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:courses) do
      primary_key :id
      String :title
      String :introduction
      String :link
      String :photo
    end
  end
end
