# frozen_string_literal: true

require 'administrate/base_dashboard'

class ExperienceDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    company: Field::String,
    title: Field::String,
    start_date: Field::Date,
    end_date: Field::Date,
    summary: Field::Text,
    is_current: Field::Boolean,
    skills: Field::HasMany,
    accomplishments: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    company
    title
    start_date
    is_current
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    company
    title
    start_date
    end_date
    is_current
    summary
    skills
    accomplishments
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    company
    title
    start_date
    end_date
    summary
    skills
  ].freeze

  COLLECTION_FILTERS = {
    current: ->(resources) { resources.current }
  }.freeze

  def display_resource(experience)
    experience.display_name
  end
end
