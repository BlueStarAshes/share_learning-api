# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:reactions_on_reviews) do
      primary_key [:review_id, :reaction_id], name: :items_pk
      foreign_key :review_id
      foreign_key :reaction_id
      Date :time
    end
  end
end
