# frozen_string_literal: true

require 'administrate/base_dashboard'

class ProfileDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    title: Field::String,
    email: Field::Email,
    phone: Field::String,
    location: Field::String,
    summary: Field::Text,
    links: Field::Text.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    title
    email
    location
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    title
    email
    phone
    location
    summary
    links
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    title
    email
    phone
    location
    summary
    links
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(profile)
    profile.display_name
  end
end
