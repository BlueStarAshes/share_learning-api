# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    alter_table(:reactions) do
      add_column :emoji, String
    end
  end
end
