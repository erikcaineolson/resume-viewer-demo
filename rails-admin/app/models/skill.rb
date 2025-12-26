# frozen_string_literal: true

class Skill < ApplicationRecord
  # PostgreSQL enum: language, framework, tool, platform, methodology
  CATEGORIES = %w[language framework tool platform methodology].freeze

  has_and_belongs_to_many :experiences, join_table: 'experience_skills'

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :proficiency_level, numericality: {
    only_integer: true,
    in: 1..5
  }

  scope :by_category, ->(cat) { where(category: cat) }
  scope :proficient, -> { where(proficiency_level: 4..5) }

  def display_name
    "#{name} (#{category})"
  end
end
