# frozen_string_literal: true

require 'administrate/base_dashboard'

class ExperienceAccomplishmentDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    experience: Field::BelongsTo,
    accomplishment: Field::Text,
    sort_order: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    experience
    accomplishment
    sort_order
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    experience
    accomplishment
    sort_order
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    experience
    accomplishment
    sort_order
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(accomplishment)
    accomplishment.display_name
  end
end
