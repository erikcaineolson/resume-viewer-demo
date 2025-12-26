# frozen_string_literal: true

require 'administrate/base_dashboard'

class SkillDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    category: Field::Select.with_options(
      collection: Skill::CATEGORIES,
      searchable: false
    ),
    proficiency_level: Field::Select.with_options(
      collection: (1..5).to_a,
      searchable: false
    ),
    experiences: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    category
    proficiency_level
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    category
    proficiency_level
    experiences
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    category
    proficiency_level
  ].freeze

  COLLECTION_FILTERS = {
    category: ->(resources, value) { resources.by_category(value) }
  }.freeze

  def display_resource(skill)
    skill.display_name
  end
end
